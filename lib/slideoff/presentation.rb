require "erubis"

module Slideoff
  class Presentation
    Theme   = Struct.new(:title, :dir, :css, :js)
    Section = Struct.new(:number, :title, :dir, :slides, :show_chapter, :show_toc)

    class Slide < Struct.new(:number, :classes, :html, :section_num)
      def id
        [section_num, number].join('-')
      end

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

      Dir[     "#{CONFIG.pwd}#{asset}"].first ||
        Dir[    "#{theme.dir}#{asset}"].first ||
        Dir[   "#{common.dir}#{asset}"].first ||
        lookup_recursive_without_static(asset).first
    end

    def convert_styles(dir)
      if Dir.exist?("#{dir}/styles") && !Dir.exist?("#{dir}/css")
        Dir.chdir(dir) { `sass --update styles:css` }
      end
    end

  protected

    def lookup_recursive_without_static(path)
      found_paths = Dir["#{File.absolute_path(CONFIG.pwd)}/**#{path}"]
      found_static_paths = Dir["#{File.absolute_path(CONFIG.static_dir)}/**#{path}"]
      found_paths - found_static_paths
    end

    def build_theme(title)
      Theme.new.tap do |t|
        dir = File.expand_path("#{CONFIG.dir}/themes/#{title}")
        if File.exists?(dir)
          t.dir = dir
        else
          t.dir = File.expand_path("../../../themes/#{title}", __FILE__)
        end
        t.title = title
        Dir.chdir(t.dir) do
          t.css = Dir["**/*.css"].sort
          t.js  = Dir["**/*.js"].sort
        end
      end
    end

    def sections
      @parts.map.with_index do |(dir, options), section_num|
        raw = Dir["#{CONFIG.pwd}/#{dir}/**/*.md"].sort.map do |f|
          File.read(f)
        end.join("\n\n")
        parts = raw.split(/!SLIDE */)
        parts.delete('')
        slide_num_diff = [options["show_chapter"], options["show_toc"]].count(true)
        slides = parts.map.with_index do |slide, slide_num|
          classes, md = slide.split("\n", 2)
          html = Markdown.render(md)
          Slide.new(slide_num+slide_num_diff, classes, html, section_num)
        end
        Section.new(section_num, options["title"], dir, slides, options["show_chapter"], options["show_toc"])
      end
    end
  end
end
