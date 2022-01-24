require 'asciidoctor'
require 'asciidoctor/extensions'

$shot_id = 0

def shot(number, title="Shot #{number}")
  $shot_id += 1
  suffix = ': ' + title if title
  shot_id = "shot-#{$shot_id}"
  %(<a href="##{shot_id}" id="#{shot_id}" title="#{title}" style="border-radius: 10px; padding: 2px 5px 2px 5px; color: white; font-weight: bold; background-color: red; font-family: sans-serif; text-decoration: none;">🎬 #{number}#{suffix}</a>)
end

class ShotInlineMacro < Asciidoctor::Extensions::InlineMacroProcessor
  use_dsl

  named :shot

  def process parent, target, attrs
    doc = parent.document
    return unless doc.attributes['shots']
    shot(attrs.values.first, attrs.values[1])
  end
end

Asciidoctor::Extensions.register do
  inline_macro ShotInlineMacro if document.basebackend? 'html'
end