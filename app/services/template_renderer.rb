class TemplateRenderer
  attr_reader :template

  def initialize(template)
    @template = template
  end

  def render(recipient)
    {
      body: render_body(recipient),
      subject: render_subject(recipient)
    }
  end

  def render_body(recipient)
    body_template.render(recipient['custom_data'])
  end

  def render_subject(recipient)
    subject_template.render(recipient['custom_data'])
  end

  def body_template
    @body_template ||= Liquid::Template.parse(template.body)
  end

  def subject_template
    @subject_template ||= Liquid::Template.parse(template.subject)
  end
end
