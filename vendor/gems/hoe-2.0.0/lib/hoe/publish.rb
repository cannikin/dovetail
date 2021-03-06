##
# Publish plugin for hoe.
#
# === Tasks Provided:
#
# announce::           Create news email file and post to rubyforge.
# email::              Generate email announcement file.
# post_blog::          Post announcement to blog.
# post_news::          Post announcement to rubyforge.
# publish_docs::       Publish RDoc to RubyForge.
# ridocs::             Generate ri locally for testing.
#
# === Extra Configuration Options:
#
# publish_on_announce:: Run +publish_docs+ when you run +release+.
# blogs::               An array of hashes of blog settings.

module Hoe::Publish
  Hoe.plugin :publish

  ##
  # *Optional*: An array of the project's blog categories. Defaults to project name.

  attr_accessor :blog_categories

  ##
  # Optional: Name of RDoc destination directory on Rubyforge. [default: +name+]

  attr_accessor :remote_rdoc_dir

  ##
  # Optional: Flags for RDoc rsync. [default: "-av --delete"]

  attr_accessor :rsync_args

  Hoe::DEFAULT_CONFIG["publish_on_announce"] = true
  Hoe::DEFAULT_CONFIG["blog"] = [
                                 {
                                   "user"     => "user",
                                   "password" => "password",
                                   "url"      => "url",
                                   "blog_id"  => "blog_id",
                                   "extra_headers" => {
                                     "mt_convert_breaks" => "markdown"
                                   },
                                 }
                                ]

  ##
  # Initialize variables for plugin.

  def initialize_publish
    self.blog_categories ||= [self.name]
    self.remote_rdoc_dir ||= self.name
    self.rsync_args      ||= '-av --delete'
  end

  ##
  # Define tasks for plugin.

  def define_publish_tasks
    Rake::RDocTask.new(:docs) do |rd|
      rd.main = readme_file
      rd.options << '-d' if (`which dot` =~ /\/dot/) unless
        ENV['NODOT'] || Hoe::WINDOZE
      rd.rdoc_dir = 'doc'

      rd.rdoc_files += spec.require_paths
      rd.rdoc_files += spec.extra_rdoc_files

      title = "#{name}-#{version} Documentation"
      title = "#{rubyforge_name}'s " + title if rubyforge_name != name

      rd.options << "-t" << title
    end

    desc 'Generate ri locally for testing.'
    task :ridocs => :clean do
      sh %q{ rdoc --ri -o ri . }
    end

    desc 'Publish RDoc to RubyForge.'
    task :publish_docs => [:clean, :docs] do
      config = YAML.load(File.read(File.expand_path("~/.rubyforge/user-config.yml")))
      host = "#{config["username"]}@rubyforge.org"

      remote_dir = "/var/www/gforge-projects/#{rubyforge_name}/#{remote_rdoc_dir}"
      local_dir = 'doc'

      sh %{rsync #{rsync_args} #{local_dir}/ #{host}:#{remote_dir}}
    end

    # no doco for this one
    task :publish_on_announce do
      with_config do |config, _|
        Rake::Task['publish_docs'].invoke if config["publish_on_announce"]
      end
    end

    desc 'Generate email announcement file.'
    task :email do
      require 'rubyforge'
      subject, title, body, urls = announcement

      File.open("email.txt", "w") do |mail|
        mail.puts "Subject: [ANN] #{subject}"
        mail.puts
        mail.puts title
        mail.puts
        mail.puts urls
        mail.puts
        mail.puts body
        mail.puts
        mail.puts urls
      end
      puts "Created email.txt"
    end

    desc 'Post announcement to blog.'
    task :post_blog do
      require 'xmlrpc/client'

      with_config do |config, path|
        break unless config['blogs']

        subject, title, body, urls = announcement
        body += "\n\n#{urls}"

        config['blogs'].each do |site|
          server = XMLRPC::Client.new2(site['url'])
          content = site['extra_headers'].merge(:title => title,
                                                :description => body,
                                                :categories => blog_categories)

          result = server.call('metaWeblog.newPost',
                               site['blog_id'],
                               site['user'],
                               site['password'],
                               content,
                               true)
        end
      end
    end

    desc 'Post announcement to rubyforge.'
    task :post_news do
      require 'rubyforge'
      subject, title, body, urls = announcement

      rf = RubyForge.new.configure
      rf.login
      rf.post_news(rubyforge_name, subject, "#{title}\n\n#{body}")
      puts "Posted to rubyforge"
    end

    desc 'Create news email file and post to rubyforge.'
    task :announce => [:email, :post_news, :post_blog, :publish_on_announce ]
  end

  def announcement # :nodoc:
    changes = self.changes.rdoc_to_markdown
    subject = "#{name} #{version} Released"
    title   = "#{name} version #{version} has been released!"
    body    = "#{description}\n\nChanges:\n\n#{changes}".rdoc_to_markdown
    urls    = Array(url).map { |s| "* <#{s.strip.rdoc_to_markdown}>" }.join("\n")

    return subject, title, body, urls
  end
end

class ::Rake::SshDirPublisher # :nodoc:
  attr_reader :host, :remote_dir, :local_dir
end

class String
  ##
  # Very basic munge from rdoc to markdown format.

  def rdoc_to_markdown
    self.gsub(/^mailto:/, '').gsub(/^(=+)/) { "#" * $1.size }
  end
end
