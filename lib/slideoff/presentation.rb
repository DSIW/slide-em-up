require "erubis"
require "yajl"


module Slideoff
  class Presentation
    Meta    = Struct.new(:title, :dir, :css, :js, :author, :duration, :pygments_style, :flickr_api_key)
    Theme   = Struct.new(:title, :dir, :css, :js)
    Section = Struct.new(:number, :title, :dir, :slides)

    class Slide < Struct.new(:number, :classes, :html)
      def extract_title
        return @title if @title
        html.sub!(/<h(\d)>(.*)<\/h\1>/) { @title = $2; "" }
        @title
      end
    end

    attr_accessor :meta, :theme, :common, :parts

    def initialize(dir)
      infos   = extract_normal_infos(dir) || extract_infos_from_showoff(dir) || {}
      infos   = { "title" => "No title", "theme" => "shower", "duration" => 60, "pygments_style" => "colorful" }.merge(infos)
      @meta   = build_meta(infos["title"], dir, infos["author"], infos["duration"], infos["pygments_style"], infos["flickr_api_key"])
      @theme  = build_theme(infos["theme"])
      @common = build_theme("common")
      @parts  = infos["sections"] || raise(Exception, "check your presentation.json or showoff.json file")
      @parts  = Hash[@parts.zip @parts] if Array === @parts
    end

    def html
      str = File.read("#{theme.dir}/index.erb")
      Erubis::Eruby.new(str).result(:meta => meta, :theme => theme, :sections => sections)
    end

    def path_for_asset(asset)
      [meta, theme, common].each { |dir| convert_styles(dir) }

      Dir[     "#{meta.dir}#{asset}"].first ||
        Dir[  "#{theme.dir}#{asset}"].first ||
        Dir[ "#{common.dir}#{asset}"].first ||
        Dir["#{meta.dir}/**#{asset}"].first
    end

    def convert_styles(dir)
      if Dir.exist?("#{dir}/styles") && !Dir.exist?("#{dir}/css")
        Dir.chdir(dir) { `sass --update styles:css` }
      end
    end

    def nb_slides
      @parts.inject(0) do |nb,(dir,title)|
        raw = Dir["#{meta.dir}/#{dir}/**/*.md"].map { |f| File.read(f) }.join("\n\n")
        nb += raw.split(/!SLIDE */).length
      end
    end

  protected

    def extract_normal_infos(dir)
      filename = "#{dir}/presentation.json"
      return unless File.exists?(filename)
      Yajl::Parser.parse(File.read filename)
    end

    def extract_infos_from_showoff(dir)
      filename = "#{dir}/showoff.json"
      return unless File.exists?(filename)
      infos = Yajl::Parser.parse(File.read filename)
      sections = infos["sections"].map {|s| s["section"] }
      { "title" => infos["name"], "theme" => "showoff", "sections" => sections }
    end

    def build_meta(title, dir, author, duration, pygments_style, flickr_api_key)
      Meta.new.tap do |m|
        m.title = title
        m.dir   = dir
        Dir.chdir(m.dir) do
          m.css = Dir["**/*.css"]
          m.js  = Dir["**/*.js"]
        end
        m.author = author
        m.duration = duration
        m.pygments_style = pygments_style
        m.flickr_api_key = ENV["FLICKR_API_KEY"] = flickr_api_key
      end
    end

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
        raw = Dir["#{meta.dir}/#{dir}/**/*.md"].sort.map { |f| File.read(f) }.join("\n\n")
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
