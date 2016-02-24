class UnsubscribeLinkTag < Liquid::Tag
  def initialize(tag_name, text, tokens)
     super
     @text = text
  end

  def render(context)
    url = [
      'http:/',
      context.registers[:domain],
      'unsubscribtions',
      context.registers[:message_id]
    ].join('/')
    "<a href=\"#{url}\">#{@text}</a>"
  end
end

Liquid::Template.register_tag('unsubscribe_link', UnsubscribeLinkTag)
