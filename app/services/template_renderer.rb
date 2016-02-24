class TemplateRenderer
  attr_reader :template, :domain_name

  def initialize(template, domain_name)
    @template = template
    @domain_name = domain_name
  end

  def render(recipient, msg_id)
    {
      body: render_body(recipient, msg_id),
      subject: render_subject(recipient, msg_id)
    }
  end

  def render_body(recipient, msg_id)
    body_template.render(
      recipient['custom_data'],
      registers: {
        message_id: msg_id,
        domain: domain_name
      }
    )
  end

  def render_subject(recipient, msg_id)
    subject_template.render(recipient['custom_data'])
  end

  def body_template
    @body_template ||= Liquid::Template.parse(template.body)
  end

  def subject_template
    @subject_template ||= Liquid::Template.parse(template.subject)
  end
end
