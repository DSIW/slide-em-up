require "fileutils"

module SlideEmUp
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
  "theme": "shower",
  "pygments_style": "colorful",
  //"duration": 20,
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
      theme_directory = File.join(ENV['HOME'], '.slide-em-up')
      FileUtils.mkdir_p theme_directory
      theme_name = git_repository_url.split('/').last
      theme_path = File.join(theme_directory, theme_name)
      puts "Cloning to #{theme_path}..."
      `git clone #{git_repository_url} #{theme_path}`
      puts "Cloned"
      puts "Please make sure that '#{theme_name}' is set as your theme in presentation.json"
    end

    # Source: https://github.com/puppetlabs/showoff/blob/master/lib/showoff_utils.rb#L100
    def github
      generate_static
      `git add static`
      sha = `git write-tree`.chomp
      tree_sha = `git rev-parse #{sha}:static`.chomp
      `git read-tree HEAD`  # reset staging to last-commit
      ghp_sha = `git rev-parse gh-pages 2>/dev/null`.chomp
      extra = ghp_sha != 'gh-pages' ? "-p #{ghp_sha}" : ''
      commit_sha = `echo 'static presentation' | git commit-tree #{tree_sha} #{extra}`.chomp
      `git update-ref refs/heads/gh-pages #{commit_sha}`
    end

    def generate_static(options = {})
      pid = Process.fork { SlideEmUp::Server.new(options).start }

      sleep 2

      dir = "static"
      FileUtils.mkdir_p(dir)
      Dir.chdir(dir) do |dir|
        `wget -E -H -k -nH -p http://lh:#{options[:port]}/`
      end

      Process.kill "QUIT", pid
      Process.wait pid
    end

    def serve_static(port)
      `python3 -m http.server #{port}`
    end
  end
end
