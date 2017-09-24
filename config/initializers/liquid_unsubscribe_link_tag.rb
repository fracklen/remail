class UnsubscribeLinkTag < Liquid::Tag
  def initialize(tag_name, text, tokens)
     super
     @text = text
  end

  def render(context)
    path = "http://#{context.registers[:domain]}/unsubscriptions/new"
    params = "unsubscriptions[uuid]=#{context.registers[:message_id]}"
    url = [path, params].join('?')
    "<a class=\"unsubscribe-link\" href=\"#{url}\">#{@text}</a>"
  end
end

Liquid::Template.register_tag('unsubscribe_link', UnsubscribeLinkTag)
