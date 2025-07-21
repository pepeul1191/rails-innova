module ApplicationHelper
  require 'redcarpet'

  class HTMLRenderer < Redcarpet::Render::HTML
    def initialize(extensions = {})
      super({
        filter_html: true,
        hard_wrap: true,
        link_attributes: { target: '_blank', rel: 'noopener' }
      }.merge(extensions))
    end
  end

  def markdown_to_html(markdown_content)
    return '' if markdown_content.blank?

    renderer = HTMLRenderer.new
    markdown = Redcarpet::Markdown.new(
      renderer,
      autolink: true,
      fenced_code_blocks: true,
      no_intra_emphasis: true,
      tables: true,
      strikethrough: true,
      space_after_headers: true
    )

    # Sanitizar y marcar como seguro
    raw markdown.render(markdown_content).html_safe
  end
end
