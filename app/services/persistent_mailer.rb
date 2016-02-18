class PersistentMailer

  attr_reader :campaign_run

  SMTP_SESSION_MAX = 100

  def initialize(campaign_run)
    @campaign_run = campaign_run
    @smtp_session = nil
    @smtp_session_count = 0
  end

  def send_mail(recipient)
    conditional_reconnect
    rendered = renderer.render(recipient)
    deliver(recipient, rendered)
    @smtp_session_count += 1
  end

  def deliver(recipient, rendered)
    mail = Mail.new do
      to recipient['email']
      from 'foobar@net.net'
      subject rendered[:subject]
      body rendered[:body]
    end

    @smtp_session.sendmail(mail.encoded,
      mail.smtp_envelope_from,
      mail.smtp_envelope_to
    )
  end

  def finish
    @smtp_session.finish if @smtp_session
  end

  def renderer
    @renderer ||= TemplateRenderer.new(campaign_run.campaign.template)
  end

  def conditional_reconnect
    if @smtp_session_count > SMTP_SESSION_MAX || @smtp_session.nil?
      @smtp_session.finish if @smtp_session
      smtp = Net::SMTP.start('localhost', 1025, 'net.test.com')
      Mail.defaults do
        delivery_method :smtp_connection, connection: smtp
      end
      @smtp_session = smtp
      @smtp_session_count = 0
    end
  end
end
