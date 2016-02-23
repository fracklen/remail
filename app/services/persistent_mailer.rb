class PersistentMailer

  attr_reader :campaign_run

  SMTP_SESSION_MAX = 1000

  def initialize(campaign_run)
    @campaign_run = campaign_run
    @smtp_session = nil
    @smtp_session_count = 0
    @delivery_buffer = DeliveryBuffer.new(campaign_run)
    @link_tracker = LinkTracker.new(campaign_run)
    @pixel_tracker = PixelTracker.new(campaign_run)
  end

  def send_mail(id, recipient)
    conditional_reconnect
    rendered = renderer.render(recipient)
    deliver(id, recipient, rendered)
    @smtp_session_count += 1
  end

  def deliver(id, recipient, rendered, try_again = true)
    msg_id = gen_message_id(recipient)
    rendered = @link_tracker.track_links(rendered, id, recipient, msg_id)
    rendered = @pixel_tracker.track_opens(rendered, msg_id)

    mail = Mail.new
    mail.to         = recipient['email']
    mail.from       = campaign.from_email
    mail.reply_to   = campaign.reply_to_email
    mail.subject    = rendered[:subject]
    mail.message_id = msg_id

    mail.text_part do
      content_type 'text/plain; charset=UTF-8'
      body ActionView::Base.full_sanitizer.sanitize(rendered[:body])
    end

    mail.html_part do
      content_type 'text/html; charset=UTF-8'
      body rendered[:body]
    end

    @smtp_session.sendmail(mail.encoded,
      mail.smtp_envelope_from,
      mail.smtp_envelope_to
    )
    @delivery_buffer.async.push(id, recipient, mail)
  rescue IOError, Net::SMTPUnknownError
    @smtp_session = nil
    conditional_reconnect
    deliver(recipient, redered, !try_again) if try_again
    raise unless try_again
  rescue Net::SMTPServerBusy, TimeoutError
    @smtp_session = nil
    sleep 1
    conditional_reconnect
    deliver(recipient, redered, !try_again) if try_again
    raise unless try_again
  rescue Net::SMTPAuthenticationError
    raise
  end

  def gen_message_id(recipient)
    "#{SecureRandom.hex}@#{domain.name}"
  end

  def finish
    @delivery_buffer.future.flush.value
    @delivery_buffer.terminate
    @link_tracker.flush
    @smtp_session.finish if @smtp_session
  end

  def renderer
    @renderer ||= TemplateRenderer.new(campaign_run.campaign.template)
  end

  def campaign
    @campaign ||= campaign_run.campaign
  end

  def domain
    @domain ||= campaign.domain
  end

  def conditional_reconnect
    if @smtp_session_count > SMTP_SESSION_MAX || @smtp_session.nil?
      @smtp_session.finish if @smtp_session
      @smtp_session = Net::SMTP.start('localhost', 1025, 'net.test.com')
      @smtp_session_count = 0
    end
  end
end
