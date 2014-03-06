require "fileutils"

module Slideoff
  module Utils
    module_function

    def init_directory(name)
      raise "Directory '#{name}' does already exist. Use another one." if Dir.exist? name
      FileUtils.mkdir_p name
      Dir.chdir(name) do |dir|
        FileUtils.mkdir_p 'main'
        File.open('main/slides.md', 'w') do |file|
          file.write <<-EOF
!SLIDE title cover w
#Title
##Subtitle

!SLIDE
# Content

* Introduction
* Design
* Implementation
* Conclusion

!SLIDE chapter
# Design
!F[3034540524]

!SLIDE section
# Architecture
!F[5862134]

!SLIDE
# Architecture

* Easy
* Simple

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

!SLIDE incremental
# Incremental list

* First item
* Second item
* Third item

!SLIDE incremental
# Content with pauses

This is the first text.

!PAUSE

More text <span class="inactive">with hidden info</span>!

!SLIDE
# Description list

ABC
  : abc
DEF
  : def

!SLIDE
# Blockquote

>Alles klar hjo joasdkb askdjb kabsdk jbaskdjb kabjd kjasbdk jbask dbaks bdkasjbd kasjb
>askdjbaksdb aksjbd aksbd aksbdaksbd aksdb aksbdaksbd askbd aksdb aks baksb dak sbda
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
# Box with different colors

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
# Box with different colors

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

![](http://upload.wikimedia.org/wikipedia/commons/4/48/Markdown-mark.svg)

!SLIDE shout up
# JPO

!SLIDE cover w

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

!F[5696337148]

!SLIDE
# Link

1. [GitHub.com](http://github.com)

!SLIDE
# Code

```sh
$ bundle install
```

```ruby
class World
  def hello
    puts "Hello World"
  end
end
```

!SLIDE
# Table

|Left column|Centered column| Right column
|-----------|:-------------:|------------:
|Dataset 1  |Dataset 1      | Dataset 2
|Dataset 1  |Dataset 2      | Dataset 2
|Dataset 1  |Dataset 3      | Dataset 2
|Dataset 1  |Dataset 4      | Dataset 2

!SLIDE
# Highlighting

__red__colorize__
This is ==orange==some== __orange__super__ and _underlined_ text.

!SLIDE
# Box

+++ box-red shadow
+++ Header
+++ Content
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
    "main":"Talk 2.0"
  }
}
          EOF
        end
        puts `git init`
      end
    end

    def install_theme(git_repository_url)
      theme_directory = File.join(ENV['HOME'], '.slideoff')
      FileUtils.mkdir_p theme_directory
      theme_name = git_repository_url.split('/').last
      theme_path = File.join(theme_directory, theme_name)
      `git clone #{git_repository_url} #{theme_path}`
      puts "Cloned"
      puts "Please make sure that '#{theme_name}' is set as your theme in presentation.json"
    end

    def upload(options = {})
      generate_static(options)
      path = CONFIG.remote_path
      mkdir_commands = parents(path).map { |path| "mkdir -vp -m 755 #{path}" }
      remote_cmd mkdir_commands
      `scp -r #{File.join(static_dir, "*")} #{CONFIG.remote_host}:#{path}`
      remote_cmd "chmod -vR o+r #{path}"
    end

    def generate_static(options = {})
      pid = Process.fork { Slideoff::Server.new(options).start }

      sleep 2

      begin
        FileUtils.mkdir_p(static_dir)
        Dir.chdir(static_dir) do |dir|
          `wget -E -H -k -nH -p http://lh:#{options[:port]}/`
          File.write('robots.txt', "User-agent: *\nDisallow: /\n")
        end
      ensure
        Process.kill "QUIT", pid
        Process.wait pid
      end
    end

    def serve_static(port, options = {})
      puts "Listening python server on http://0.0.0.0:#{port}" if options[:verbose]
      `python3 -m http.server #{port}`
    end


    def parents(dir)
      splitted = dir.split(File::SEPARATOR)
      splitted.length.times.reduce([]) { |_parents, i| _parents << splitted[0..i].join(File::SEPARATOR) }
    end

    def remote_cmd(cmds)
      `ssh #{CONFIG.remote_host} "#{Array(cmds).join(';')}"`
    end

    def static_dir
      "../static_#{File.basename(Dir.pwd)}"
    end
  end
end
