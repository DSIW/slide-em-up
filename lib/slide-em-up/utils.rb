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
!SLIDE
#My first slide

* First point
* Second point
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
