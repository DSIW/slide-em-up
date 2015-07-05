require "fileutils"

module Slideoff
  module Utils
    module_function

    def init_directory(name)
      raise "Directory '#{name}' does already exist. Use another one." if Dir.exist? name
      FileUtils.mkdir_p name
      Dir.chdir(name) do |dir|
        FileUtils.mkdir_p 'main'
        File.open('main/index.md', 'w') do |file|
          file.write <<-EOF
!SLIDE title cover h
#Title
##Subtitle
![Image](https://farm4.staticflickr.com/3254/3034540524_2412428602_b.jpg)

!SLIDE cover w
![Image](https://farm4.staticflickr.com/3254/3034540524_2412428602_b.jpg)

!SLIDE cover h
![Image](https://farm4.staticflickr.com/3254/3034540524_2412428602_b.jpg)

!SLIDE cover w h
![Image](https://farm4.staticflickr.com/3254/3034540524_2412428602_b.jpg)

!SLIDE
# Normal list

* Keep
* It
* Super
* Simple

!SLIDE chapter h
# Chapter
![Image](https://farm4.staticflickr.com/3254/3034540524_2412428602_b.jpg)

!SLIDE section h
# Section
![Image](https://farm4.staticflickr.com/3254/3034540524_2412428602_b.jpg)

!SLIDE shout up
# Shout up!

!SLIDE shout left
# Shout left!

!SLIDE shout right
# Shout right!

!SLIDE shout down
# Shout down!

!SLIDE
# Bullet list

* Keep
* It
* Super
* Simple

!SLIDE
# Numbered list

1. Keep
1. It
1. Super
1. Simple

!SLIDE small
# Small slide with full of text

Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut.

!SLIDE
# Description list

Ruby
  : Loving scripting language
HTTP
  : Hyper Text Transfer Protocol
CSS
  : Cascading Style Sheet
REST
  : Representational state transfer

!SLIDE
# Link

1. Click on [DSIW/slideoff](http://github.com/DSIW/slideoff).

!SLIDE
# Code

```sh
$ gem install slideoff
```

```ruby
class World
  def hello
    puts "Hello \#{self.class.name}!"
  end
end

World.new.hello #=> "Hello World!"
```

Note: Code `self.class.name` will be evaluated.

!SLIDE
# Table

|Left column|Centered column| Right column
|-----------|:-------------:|------------:
|Dataset 1  |Dataset 1      | Dataset 2
|Dataset 1  |Dataset 2      | Dataset 2
|Dataset 1  |Dataset 3      | Dataset 2
|Dataset 1  |Dataset 4      | Dataset 2

!SLIDE
# Colors

1. <span class="text-green">abc</span>
1. <span class="text-red">abc</span>
1. <span class="text-purple">abc</span>
1. <span class="text-orange">abc</span>
1. <span class="text-blue">abc</span>
1. <span class="text-bluegreen">abc</span>

!SLIDE
# Highlighting

1. <mark class="green">abc</mark>
1. <mark class="red">abc</mark>
1. <mark class="purple">abc</mark>
1. <mark class="orange">abc</mark>
1. <mark class="blue">abc</mark>
1. <mark class="bluegreen">abc</mark>

!SLIDE
# Colorize with custom markdown

This is ==orange==some== __orange__super__ and _underlined_ text.

!SLIDE incr-list
# Incremental list

* First item
* Second item
* Third item

!SLIDE incr-code
# Incremental Code

```ruby
1.class #=> Fixnum
1.1.class #=> Float
"abc".clas #=> String
:abc.clas #=> Symbol
```

!SLIDE typewriter
# Incremental Code

```sh
bundle install
```

!SLIDE incr-table
# Incremental table

|Left column|Centered column| Right column
|-----------|:-------------:|------------:
|Dataset 1  |Dataset 1      | Dataset 2
|Dataset 1  |Dataset 2      | Dataset 2
|Dataset 1  |Dataset 3      | Dataset 2
|Dataset 1  |Dataset 4      | Dataset 2

!SLIDE incremental
# Content with pauses

This is the first text.

!PAUSE

More text <span class="inactive">with hidden info</span>!

!SLIDE disabled
# Hidden slide

!SLIDE
# Blockquote

>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut.
>
>Athor Name

!SLIDE
# Box

+++
+++ Box without shadow
+++ Content

+++ shadow
+++ Box with shadow
+++ Content

!SLIDE
# Arranged Box

<div class="col2">
  <div class="box box-alert">
    <div>Errors</div>
    <div>aren't good</div>
  </div>

  <div class="inactive">
    <div class="box box-success">
      <div>No errors</div>
      <div>are better</div>
    </div>
  </div>
</div>

!SLIDE
# Box with different colors (1)

+++ box-blue
+++ Header
+++ Content

+++ box-bluegreen
+++ Header
+++ Content

+++ box-green
+++ Header
+++ Content

!SLIDE
# Box with different colors (2)

+++ box-red
+++ Header
+++ Content

+++ box-purple
+++ Header
+++ Content

+++ box-orange
+++ Header
+++ Content

!SLIDE
# Image

![Markdown](http://upload.wikimedia.org/wikipedia/commons/4/48/Markdown-mark.svg)

!SLIDE img-place-middle
# Centered Image

![Markdown](http://upload.wikimedia.org/wikipedia/commons/4/48/Markdown-mark.svg)

!SLIDE section cover w
# Image via Flickr API

!F[22565509]

!SLIDE
# Placement with "place t r b l"

<span class="bg-red place">center</span>
<span class="bg-red place t">top</span>
<span class="bg-red place t l">top-left</span>
<span class="bg-red place t r">top-right</span>
<span class="bg-red place l">left</span>
<span class="bg-red place r">right</span>
<span class="bg-red place b">bottom</span>
<span class="bg-red place b l">bottom-left</span>
<span class="bg-red place b r">bottom-right</span>

!SLIDE
# Diagram with Highcharts

<div id="diagram-pie" style="width: 850px; height: 565px;"></div>
<script type="text/javascript">
$(function () {
  $('#diagram-pie').highcharts({
    credits: { enabled: false },
    plotOptions: {
      pie: {
        cursor: 'pointer',
        dataLabels: {
          enabled: true,
          distance: 40,
          style: {
            fontSize: '23px',
            color: 'black'
          },
          formatter: function() {
            return '<b>'+ this.point.name +'</b> ('+this.point.year+'): '+ Math.round(this.percentage*10)/10.0 +'%';
          }
        }
      }
    },
    series: [{
      type: 'pie',
      innerSize: '45%',
      data: [
        { name: 'Dataset 1', year: '1980', y: 1.3,  },
        { name: 'Dataset 2', year: '1990', y: 0.3,  },
        { name: 'Dataset 3', year: '2000', y: 10.0, },
        { name: 'Dataset 4', year: '2010', y: 88.3, },
        { name: 'Dataset 5', year: '2020', y: 0.1   }
      ]
    }]
  });
});
</script>


!SLIDE noheader cover h

<div class="left-33">
  <p style="font: 500 46px/1 'Open Sans'" class="text-center">Header</p>
  <p style="font-size: 28px;" class="text-center">Subheader</p>

  <ul class="border-separated">
    <li>list item</li>
    <li>list item</li>
    <li>list item</li>
    <li>list item</li>
  </ul>
</div>

![Image](https://farm4.staticflickr.com/3254/3034540524_2412428602_b.jpg)

!SLIDE
# Clickbindings

Click                           | Action
------------------------------- | -------------------------
Left click                      | Goto next slide
Right click                     | Goto previous slide

!SLIDE
# Keybindings (1)

Key                             | Action
------------------------------- | -------------------------
F5 / Enter                      | Goto slide mode
Esc                             | Goto list mode
Home                            | Goto first slide
End                             | Goto last slide

!SLIDE
# Keybindings (2)

Key                             | Action
------------------------------- | -------------------------
Tab / Space                     | Goto next slide
... with Shift                  | Goto previous slide
PageUp / Up / Left / h / k      | Goto previous slide
... with Shift                  | Goto previous chapter
PageDown / Down / right / l / j | Goto next slide
... with Shift                  | Goto next chapter
          EOF
        end
        File.open('presentation.json', 'w') do |file|
          file.write <<-EOF
{
  "title": "#{name}",
  "author": "Me",
  "theme": "modern",
  "pygments_style": "github",
  //"duration": 20,
  //"flickr_api_key": "...",
  //"remote_host": "...",
  //"remote_path": "...",
  "sections": {
    "main": {"title": "Modern theme", "show_chapter": false, "show_toc": false}
  }
}
          EOF
        end
        File.open('style.css', 'w') do |file|
          file.write <<-EOF
/* Override your theme styles */
.slide {
}
          EOF
        end
        puts `git init`
      end
    end

    def install_theme(git_repository_url, theme_name)
      theme_name ||= git_repository_url.split('/').last.gsub(/slideoff-|theme-/, '')
      theme_path = File.join(CONFIG.dir, 'themes', theme_name)
      FileUtils.mkdir_p File.dirname(theme_path)
      `git clone #{git_repository_url} #{theme_path}`

      puts
      puts "Please make sure that '#{theme_name}' is set in your presentation.json"
    end

    def upload(options = {})
      generate_static(options)
      path = CONFIG.remote_path
      mkdir_commands = parents(path).map { |path| "mkdir -vp -m 755 #{path}" }
      remote_cmd mkdir_commands
      `scp -r #{File.join(CONFIG.static_dir, "*")} #{CONFIG.remote_host}:#{path}`
      remote_cmd "chmod -vR o+r #{path}"
    end

    def generate_static(options = {})
      fork_server(options) do
        FileUtils.mkdir_p(CONFIG.static_dir, verbose: true)
        FileUtils.rm_rf(Dir[File.join(CONFIG.static_dir, '*')], verbose: true)
        Dir.chdir(CONFIG.static_dir) do |dir|
          `wget -E -H -k -nH -p http://127.0.0.1:#{options[:port]}/`
          File.write('robots.txt', "User-agent: *\nDisallow: /\n")
        end
      end
    end

    def serve_static(port, options = {})
      Dir.chdir(CONFIG.static_dir) do
        puts "Listening python server on http://0.0.0.0:#{port}" if options[:verbose]
        `python3 -m http.server #{port}`
      end
    end

    def generate_pdf_file(options = {})
      pdf_file = "talk_#{convert_to_filename(CONFIG.title)}.pdf"
      fork_server(options) do
        page_width = '8000px'
        page_height = '6000px'
        page_margin = 0
        source = "http://127.0.0.1:#{options[:port]}"
        dest = pdf_file
        `wkhtmltopdf --page-width #{page_width} --page-height #{page_height} -B #{page_margin} -R #{page_margin} -L #{page_margin} -T #{page_margin} #{source} #{dest}`
      end

      pdf_file
    end

    private

    def self.parents(dir)
      splitted = dir.split(File::SEPARATOR)
      splitted.length.times.reduce([]) { |_parents, i| _parents << splitted[0..i].join(File::SEPARATOR) }
    end

    def self.remote_cmd(cmds)
      `ssh #{CONFIG.remote_host} "#{Array(cmds).join(';')}"`
    end

    def self.convert_to_filename(string)
      string.downcase.gsub(/[^a-z0-9.-]/, '')
    end

    def self.fork_server(options)
      pid = Process.fork { Slideoff::Server.new(options).start }
      sleep 2

      begin
        yield
      ensure
        Process.kill "QUIT", pid
        Process.wait pid
      end
    end
  end
end
