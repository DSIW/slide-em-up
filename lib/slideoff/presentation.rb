require "erubis"

module Slideoff
  class Presentation
    Theme   = Struct.new(:title, :dir, :css, :js)
    Section = Struct.new(:number, :title, :dir, :slides)

    class Slide < Struct.new(:number, :classes, :html)
      def extract_title
        return @title if @title
        html.sub!(/<h(\d)>(.*)<\/h\1>/) { @title = $2; "" }
        @title
      end

      def extract_subtitle
        return @subtitle if @subtitle
        html.sub!(/<h(\d)>(.*)<\/h\1>/) { @subtitle = $2; "" }
        @subtitle
      end
    end

    attr_accessor :theme, :common, :parts

    def initialize(dir)
      @theme  = build_theme(CONFIG.theme)
      @common = build_theme("common")
      @parts  = CONFIG.sections || raise("check your presentation.json or showoff.json file")
      @parts  = Hash[@parts.zip @parts] if Array === @parts
    end

    def html
      str = File.read("#{theme.dir}/index.erb")
      Erubis::Eruby.new(str).result(:meta => CONFIG, :theme => theme, :sections => sections)
    end

    def path_for_asset(asset)
      [CONFIG, theme, common].each { |dir| convert_styles(dir) }

      Dir[     "#{CONFIG.dir}#{asset}"].first ||
        Dir[  "#{theme.dir}#{asset}"].first ||
        Dir[ "#{common.dir}#{asset}"].first ||
        Dir["#{CONFIG.dir}/**#{asset}"].first
    end

    def convert_styles(dir)
      if Dir.exist?("#{dir}/styles") && !Dir.exist?("#{dir}/css")
        Dir.chdir(dir) { `sass --update styles:css` }
      end
    end

    def nb_slides
      @parts.inject(0) do |nb,(dir,title)|
        raw = Dir["#{CONFIG.dir}/#{dir}/**/*.md"].map { |f| File.read(f) }.join("\n\n")
        nb += raw.split(/!SLIDE */).length
      end
    end

  protected

    def build_theme(title)
      Theme.new.tap do |t|
        dir = File.expand_path("~/.slideoff/#{title}")
        if File.exists?(dir)
          t.dir = dir
        else
          t.dir = File.expand_path("../../../themes/#{title}", __FILE__)
        end
        t.title = title
        Dir.chdir(t.dir) do
          t.css = Dir["**/*.css"]
          t.js  = Dir["**/*.js"]
        end
      end
    end

    def sections
      @parts.map.with_index do |(dir,title),i|
        raw = Dir["#{CONFIG.dir}/#{dir}/**/*.md"].sort.map { |f| File.read(f) }.join("\n\n")
        parts = raw.split(/!SLIDE */)
        parts.delete('')
        slides = parts.map.with_index do |slide,j|
          @codemap = {}
          classes, md = slide.split("\n", 2)
          html = Markdown.render(md)
          Slide.new(j, classes, html)
        end
        Section.new(i, title, dir, slides)
      end
    end
  end
end
