# Encoding: utf-8
require "pygments"
require "redcarpet"
require "cgi"

module Slideoff
  class Markdown < Redcarpet::Render::HTML
    PARSER_OPTIONS = {
      :no_intra_emphasis  => true,
      :tables             => true,
      :fenced_code_blocks => true,
      :disable_indented_code_blocks => true,
      :autolink           => true,
      :strikethrough      => true,
      :superscript        => true,
      :quote              => true,
      :underline          => true,
      :lax_spacing        => true,
      :highlight          => true
    }

    def self.render(text)
      text ||= ""
      markdown = Redcarpet::Markdown.new(self, PARSER_OPTIONS)
      markdown.render(text)
    end

    def preprocess(text)
      parse_highlight(text)
      parse_box(text)
      parse_colorizing(text)
      parse_description(text)
      parse_flickr_image(text)
      parse_pause(text)
      text
    end

    def parse_box(text)
      text.gsub!(/(\+\+\+)(.*?)\n\1(.+?)\n\1(.+?)(\n|$)/m) do
        %{<div class="box #{$2}"><div>#{$3}</div><div>#{$4}</div></div>}
      end
    end

    def parse_highlight(text)
      text.gsub!(/(==)(.*?)\1(.*?)\1/) do
        %{<mark class="#{$2}">#{$3}</mark>}
      end
    end

    def parse_colorizing(text)
      text.gsub!(/(__)(.*?)\1(.*?)\1/) do
        %{<span class="text-#{$2}">#{$3}</span>}
      end
    end

    def parse_description(text)
      item = /([^\n]+?)\n/
      separator = /\s*:\s+/
      text.gsub!(/(#{item}#{separator}#{item})+/m) do |m|
        scanned = m.scan(/#{item}#{separator}#{item}/m)
        html_list = scanned.map { |(word, desc)| %{<dt>#{word}</dt><dd>#{desc}</dd>} }.join
        %Q{<dl>#{html_list}</dl>}
      end
    end

    def parse_flickr_image(text)
      text.gsub!(/!F\[(.+?)\](?:\[(.+?)\])?/) do
        id = $1
        size = $2 || :b
        begin
          flickr_image = FlickrImage.new(id)
          src = flickr_image.image_src #(size)
          author = flickr_image.author
          license = flickr_image.license["name"]
          license_url = flickr_image.license["url"]
          cc_attributes = flickr_image.license["cc_attributes"]
          alt = flickr_image.title
          page = flickr_image.page
        rescue Exception => e
          title = "Specify Flickr API key!"
          src = "http://www.placehold.it/1024x807&text=#{CGI.escape(title)}"
          author = "No author"
          license = "All Rights Reserved"
          license_url = ""
          cc_attributes = nil
          alt = title
          page = src
        end

        html = "<figure>"
        html << %{<img alt="#{alt}" src="#{src}"/>}
        html << "<figcaption>"
        html << %{<span class="flickr"></span>}
        html << %{<a href="#{page}" alt="#{author} on Flickr">#{author}</a>}
        html << %{<a href="#{license_url}" alt="#{license}">}
        if cc_attributes && cc_attributes.any?
          html << %{<span class="license license-cc"></span>}
          #cc_attributes.each do |cc|
            #html << %{<span class="license license-#{cc}"></span>}
          #end
        end
        html << %{</a>}
        html << "</figcaption>"
        html << "</figure>"
        html
      end
    end

    def parse_pause(text)
      text.gsub!(/^!PAUSE\s*$/) { %{<p class="pause"></p>} }
    end

    def block_code(code, lang)
      colorized = Pygments.highlight(code, :lexer => lang || "text", :options => {:nowrap => true})
      code_lines = colorized.split("\n")
      code_lines.map! do |line|
        line = %{<span>&nbsp;</span>} if line.empty?
        %{<code>#{line}</code>}
      end
      lang = "data-lang=\"#{lang}\"" if !lang.nil? && !lang.empty?
      %{<pre #{lang}>#{code_lines.join}</pre>}
    end

    def codespan(code)
      %{<code class="inline">#{code}</code>}
    end

    def table(header, body)
      %{<table class="striped"><thead>#{header}</thead><tbody>#{body}</tbody></table>}
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
