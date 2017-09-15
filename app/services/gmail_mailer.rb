class GmailMailer

  attr_reader :campaign_run

  SMTP_SESSION_MAX = 1000

  def initialize(campaign_run)
    @campaign_run = campaign_run
    @smtp_session = nil
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
    delivery_buffer.push(id, recipient, mail)
  rescue IOError, Net::SMTPUnknownError
    @smtp_session = nil
    conditional_reconnect
    deliver(recipient, rendered, !try_again) if try_again
    raise unless try_again
  rescue Net::SMTPServerBusy, TimeoutError
    @smtp_session = nil
    sleep 1
    conditional_reconnect
    deliver(recipient, rendered, !try_again) if try_again
    raise unless try_again
  rescue Net::SMTPAuthenticationError
    raise
  end

  def create_mail(recipient, rendered, msg_id)
    email = @smtp_session.compose do
      to recipient['email']
      message_id msg_id
      subject rendered[:subject]
      body ActionView::Base.full_sanitizer.sanitize(rendered[:body])
    end
    email.deliver!
    email
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
    if @smtp_session_count > SMTP_SESSION_MAX || @smtp_session.nil?
      @smtp_session.logout if @smtp_session
      @smtp_session = start_random_session
      @smtp_session_count = 0
    end
  end

  def start_random_session
    account = pick_random_account()
    Gmail.connect!(account.username, account.password)
  end

  def customer
    @customer ||= campaign.customer
  end

  def gmail_accounts
    @gmail_accounts ||= Users::GmailAccount.where(customer: customer).all
  end

  def pick_random_account
    gmail_accounts.shuffle.first
  end
end
