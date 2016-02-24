class Users::TemplatesController < CustomerController
  def index
    @templates = Template
      .where(deleted_at: nil)
      .all
      .paginate(page: params[:page])
  end

  def new
    @template = Template.new
  end

  def create
    @template = Template.new(template_params)
    if @template.save
      redirect_to [:users, @template], notice: 'Template created'
    else
      render :new
    end
  end

  def update
    @template = Template.find(params[:id])
    if @template.update(template_params)
      render :show, notice: 'Template updated'
    else
      render :show
    end
  end

  def show
    @template = Template.find(params[:id])
  end

  def destroy
    @template = Template.find(params[:id])
    @template.deleted_at = Time.zone.now
    @template.save
    render json: { archived: 'OK', id: params[:id] }
  end

  def preview
    @template = Template.find(params[:id])
    response.headers['Content-Type'] = 'text/html'
    render text: TemplateRenderer
      .new(@template, domain)
      .render(
        {
          'custom_data' => @template.example_data
        },
        test_id
      )[:body]
  end

  private

  def test_id
    "#{SecureRandom.hex}@#{domain}"
  end

  def template_params
    params.require(:template).permit(
      :name,
      :body,
      :subject,
      :example_recipient
    ).merge(customer)
  end

  def customer
    {
      customer_id: current_user.customer_id
    }
  end

  def domain
    current_user.customer.domains.last.name
  end
end
