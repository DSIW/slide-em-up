# Encoding: utf-8
require "pygments"
require "redcarpet"


module SlideEmUp
  class Markdown < Redcarpet::Render::HTML
    PARSER_OPTIONS = {
      :no_intra_emphasis  => true,
      :tables             => true,
      :fenced_code_blocks => true,
      :autolink           => true,
      :strikethrough      => true,
      :superscript        => true
    }

    def self.render(text)
      text ||= ""
      markdown = Redcarpet::Markdown.new(self, PARSER_OPTIONS)
      markdown.render(text)
    end

    def preprocess(text)
      parse_flickr_image(text)
      text
    end

    def parse_flickr_image(text)
      text.gsub!(/!F\[(.+?)\](?:\[(.+?)\])?/) do
        id = $1
        size = $2 || :b
        flickr_image = FlickrImage.new(id)
        src = flickr_image.image_src #(size)
        author = flickr_image.author
        license = flickr_image.license["name"]
        license_url = flickr_image.license["url"]
        cc_attributes = flickr_image.license["cc_attributes"]
        alt = flickr_image.title
        page = flickr_image.page
        if src.include? "flickr"
          html = "<figure>"
          html << %{<img alt="#{alt}" src="#{src}"/>}
          html << "<figcaption>"
          html << %{<img src="../images/flickr.svg" class="flickr" />}
          html << %{<a href="#{page}" alt="#{author} on Flickr">#{author}</a>}
          html << %{<a href="#{license_url}" alt="#{license}">}
          if cc_attributes.any?
            html << %{<span class="license license-cc"></span>}
            #cc_attributes.each do |cc|
              #html << %{<span class="license license-#{cc}"></span>}
            #end
          end
          html << %{</a>}
          html << "</figcaption>"
          html << "</figure>"
          html
        else
          %{<img alt="#{alt}" src="#{src}"/>}
        end
      end
    end

    def block_code(code, lang)
      colorized = Pygments.highlight(code, :lexer => lang || "text", :options => {:nowrap => true})
      "<pre><code class=\"#{lang}\">#{colorized}</code></pre>"
    end

    def strikethrough(text)
      "<s>#{text}</s>"
    end

    def normal_text(text)
      text.gsub!('« ', '«&nbsp;')
      text.gsub!(/ ([:;»!?])/, '&nbsp;\1')
      text.gsub!(' -- ', '—')
      text.gsub!('...', '…')
      text
    end

  end
end
