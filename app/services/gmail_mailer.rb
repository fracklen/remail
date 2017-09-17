class GmailMailer

  attr_reader :campaign_run
  attr_reader :service

  SMTP_SESSION_MAX = 50

  def initialize(campaign_run)
    @campaign_run = campaign_run
    @smtp_session_count = 0
  end

  def send_mail(id, recipient)
    conditional_reconnect
    msg_id = gen_message_id(recipient)
    rendered = renderer.render(recipient, msg_id)
    deliver(id, msg_id, recipient, rendered)
    @smtp_session_count += 1
  end

  def deliver(id, msg_id, recipient, rendered, try_again = true)
    rendered = link_tracker.track_links(rendered, id, msg_id)
    rendered = pixel_tracker.track_opens(rendered, msg_id)
    mail = create_mail(recipient, rendered, msg_id)
    Rails.logger.info(mail.inspect)
    delivery_buffer.push(id, recipient, mail)
  rescue => exception
    Raven.capture_exception(exception)
    raise exception
  end

  def create_mail(recipient, rendered, msg_id)
    service.sendmail({
      to: recipient['email'],
      subject: rendered[:subject],
      body: ActionView::Base.full_sanitizer.sanitize(rendered[:body])
    })
  end

  def gen_message_id(recipient)
    "#{SecureRandom.hex}@#{domain.name}"
  end

  def finish
    delivery_buffer.flush
    link_tracker.flush
    link_tracker.finish
    @smtp_session.logout if @smtp_session
  end

  def renderer
    @renderer ||= TemplateRenderer.new(
      campaign_run.campaign.template,
      campaign_run.campaign.domain.name
    )
  end

  def campaign
    @campaign ||= campaign_run.campaign
  end

  def domain
    @domain ||= campaign.domain
  end

  def delivery_buffer
    @delivery_buffer ||= DeliveryBuffer.new(campaign_run)
  end

  def link_tracker
    @link_tracker ||= LinkTracker.new(campaign_run)
  end

  def pixel_tracker
    @pixel_tracker ||= PixelTracker.new(campaign_run)
  end

  def conditional_reconnect
    if @smtp_session_count > SMTP_SESSION_MAX || @service.nil?
      @service = nil
      @smtp_session_count = 0
    end
  end

  def customer
    @customer ||= campaign.customer
  end

  def gmail_accounts
    @gmail_accounts ||= Users::GmailAccount.where(customer: customer).all
  end

  def pick_random_account
    gmail_accounts
      .select {|acc| GmailService.new(acc.username).authorization_url.nil? }
      .shuffle
      .first
  end

  def service
    @service ||= GmailService.new(pick_random_account.username)
  end
end
