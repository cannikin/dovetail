# -*- ruby -*-

require 'rubygems'
require 'rake'
require 'rake/gempackagetask'
begin
  require 'rdoc/task'
rescue LoadError
  require 'rake/rdoctask'
end
require 'rake/testtask'
require 'rbconfig'
require 'rubyforge'
require 'yaml'

begin
  gem 'rdoc'
rescue Gem::LoadError
end

##
# Hoe is a simple rake/rubygems helper for project Rakefiles. It helps
# generate rubygems and includes a dynamic plug-in system allowing for
# easy extensibility. Hoe ships with plug-ins for all your usual
# project tasks including rdoc generation, testing, packaging, and
# deployment.
#
# == Using Hoe
#
# === Basics
#
# Sow generates a new project from scratch. Sow uses a simple ERB
# templating system allowing you to capture patterns common to your
# projects. Run `sow` and then see ~/.hoe_template for more info:
#
#   % sow project_name
#   ...
#   % cd project_name
#
# and have at it.
#
# === Extra Configuration Options:
#
# Hoe maintains a config file for cross-project values. The file is
# located at <tt>~/.hoerc</tt>. The file is a YAML formatted config file with
# the following settings (extended by plugins):
#
# exclude:: A regular expression of files to exclude from +check_manifest+.
#
# Run <tt>`rake config_hoe`</tt> and see ~/.hoerc for examples.
#
# == Extending Hoe
#
# Hoe can be extended via its plugin system. Hoe searches out all
# installed files matching <tt>'hoe/*.rb'</tt> and loads them. Those files are
# expected to define a module matching the file name. The module must
# define a define task method and can optionally define an initialize
# method. Both methods must be named to match the file. eg
#
#   module Hoe::Blah
#     def initialize_blah # optional
#       # ...
#     end
#
#     def define_blah_tasks
#       # ...
#     end
#   end

class Hoe
  # duh
  VERSION = '2.0.0'

  ##
  # Used to add extra flags to RUBY_FLAGS.

  RUBY_DEBUG = ENV['RUBY_DEBUG']

  default_ruby_flags = "-w -I#{%w(lib ext bin test).join(File::PATH_SEPARATOR)}" +
    (RUBY_DEBUG ? " #{RUBY_DEBUG}" : '')

  ##
  # Used to specify flags to ruby [has smart default].

  RUBY_FLAGS = ENV['RUBY_FLAGS'] || default_ruby_flags

  ##
  # Default configuration values for .hoerc. Plugins should populate
  # this on load.

  DEFAULT_CONFIG = {
    "exclude" => /tmp$|CVS|\.svn|\.log$/,
  }

  ##
  # True if you're a masochist developer. Used for building commands.

  WINDOZE = /mswin|mingw/ =~ RUBY_PLATFORM unless defined? WINDOZE

  ##
  # *MANDATORY*: The author(s) of the package. (can be array)

  attr_accessor :author

  ##
  # Optional: A description of the release's latest changes. Auto-populates.

  attr_accessor :changes

  ##
  # Optional: A description of the project. Auto-populates.

  attr_accessor :description

  ##
  # Optional: What sections from the readme to use for
  # auto-description. Defaults to %w(description).

  attr_accessor :description_sections

  ##
  # *MANDATORY*: The author's email address(es). (can be array)

  attr_accessor :email

  ##
  # Optional: An array of rubygem dependencies.

  attr_accessor :extra_deps

  ##
  # Optional: An array of rubygem developer dependencies.

  attr_accessor :extra_dev_deps

  ##
  # Optional: Extra files you want to add to RDoc.
  #
  # .txt files are automatically included (excluding the obvious).

  attr_accessor :extra_rdoc_files

  ##
  # Optional: The filename for the project history. [default: History.txt]

  attr_accessor :history_file

  ##
  # *MANDATORY*: The name of the release.

  attr_accessor :name

  ##
  # Optional: A post-install message to be displayed when gem is installed.

  attr_accessor :post_install_message

  ##
  # Optional: The filename for the project readme. [default: README.txt]

  attr_accessor :readme_file

  ##
  # Optional: The name of the rubyforge project. [default: name.downcase]

  attr_accessor :rubyforge_name

  ##
  # The Gem::Specification.

  attr_accessor :spec # :nodoc:

  ##
  # Optional: A hash of extra values to set in the gemspec. Value may be a proc.

  attr_accessor :spec_extras

  ##
  # Optional: A short summary of the project. Auto-populates.

  attr_accessor :summary

  ##
  # Optional: Number of sentences from description for summary. Defaults to 1.

  attr_accessor :summary_sentences

  ##
  # Optional: An array of test file patterns [default: test/**/test_*.rb]

  attr_accessor :test_globs

  ##
  # Optional: The url(s) of the project. (can be array). Auto-populates.

  attr_accessor :url

  ##
  # *MANDATORY*: The version. Don't hardcode! use a constant in the project.

  attr_accessor :version

  ##
  # Add extra dirs to both $: and RUBY_FLAGS (for test runs and rakefile deps)

  def self.add_include_dirs(*dirs)
    dirs = dirs.flatten
    $:.unshift(*dirs)
    s = File::PATH_SEPARATOR
    RUBY_FLAGS.sub!(/-I/, "-I#{dirs.join(s)}#{s}")
  end

  ##
  # Find and load all plugin files.
  #
  # It is called at the end of hoe.rb

  def self.load_plugins
    loaded = {}

    Gem.find_files("hoe/*.rb").each do |plugin|
      name = File.basename plugin
      next if loaded[name]
      begin
        load plugin
        loaded[name] = true
      rescue LoadError => e
        warn "error loading #{plugin.inspect}: #{e.message}. skipping..."
      end
    end
  end

  ##
  # Normalize a project name into the project, file, and klass cases (?!?).
  #
  # no, I have no idea how to describe this. Does the thing with the stuff.

  def self.normalize_names project # :nodoc:
    project   = project.tr('-', '_').gsub(/([A-Z])/, '_\1').downcase.sub(/^_/, '')
    klass     = project.gsub(/(?:^|_)([a-z])/) { $1.upcase }
    file_name = project

    return project, file_name, klass
  end

  ##
  # Activate a plugin.

  def self.plugin name
    self.plugins << name
  end

  ##
  # Return the list of activated plugins.

  def self.plugins
    @@plugins ||= []
  end

  ##
  # Create a new hoe-specification executing the supplied block

  def self.spec name, &block
    spec = self.new name
    spec.activate_plugins
    spec.instance_eval(&block)
    spec.post_initialize
    spec # TODO: remove?
  end

  ##
  # Activate plugin modules and add them to the current instance.

  def activate_plugins
    self.class.constants.reject { |n| n =~ /^[A-Z_]+$/ }.each do |name|
      self.extend Hoe.const_get(name)
    end

    self.class.plugins.each do |plugin|
      send "initialize_#{plugin}" rescue nil
    end
  end

  ##
  # Add standard and user defined dependencies to the spec.

  def add_dependencies
    hoe_deps = {
      'rake'      => ">= #{RAKEVERSION}",
      'rubyforge' => ">= #{::RubyForge::VERSION}",
    }

    self.extra_deps     = normalize_deps extra_deps
    self.extra_dev_deps = normalize_deps extra_dev_deps

    if name == 'hoe' then
      hoe_deps.each do |pkg, vers|
        extra_deps << [pkg, vers]
      end
    else
      extra_dev_deps << ['hoe', ">= #{VERSION}"] unless hoe_deps.has_key? name
    end
  end

  ##
  # Define the Gem::Specification.

  def define_spec
    self.spec = Gem::Specification.new do |s|
      dirs = Dir['{lib,ext}']

      s.name                 = name
      s.version              = version if version
      s.summary              = summary
      s.email                = email
      s.homepage             = Array(url).first
      s.rubyforge_project    = rubyforge_name
      s.description          = description
      s.files                = File.read("Manifest.txt").split(/\r?\n\r?/)
      s.executables          = s.files.grep(/^bin/) { |f| File.basename(f) }
      s.bindir               = "bin"
      s.require_paths        = dirs unless dirs.empty?
      s.rdoc_options         = ['--main', readme_file]
      s.has_rdoc             = true
      s.post_install_message = post_install_message
      s.test_files           = Dir[*self.test_globs]

      case author
      when Array
        s.authors = author
      else
        s.author  = author
      end

      extra_deps.each do |dep|
        s.add_dependency(*dep)
      end

      extra_dev_deps.each do |dep|
        s.add_development_dependency(*dep)
      end

      s.extra_rdoc_files += s.files.grep(/txt$/)
      s.extra_rdoc_files.reject! { |f| f =~ %r%^(test|spec|vendor|template|data|tmp)/% }
      s.extra_rdoc_files += @extra_rdoc_files

      # Do any extra stuff the user wants
      spec_extras.each do |msg, val|
        case val
        when Proc
          val.call(s.send(msg))
        else
          s.send "#{msg}=", val
        end
      end
    end

    unless self.version then
      version = nil

      spec.files.each do |file|
        next unless File.exist? file
        version = File.read(file)[/VERSION = ([\"\'])([\d\.]+)\1/, 2]
        break if version
      end

      spec.version = self.version = version
    end

    raise "Need version" unless self.version
  end

  ##
  # Convenience method to set add to both the author and email fields.

  def developer name, email
    self.author << name
    self.email  << email
  end

  ##
  # Create a newly initialized hoe spec. If a block is given, yield on
  # it and finish post_initialize steps. This is deprecated behavior
  # and should be switched from Hoe.new to Hoe.spec.

  def initialize name, version = nil # :nodoc:
    self.name                 = name
    self.version              = version

    self.author               = []
    self.changes              = nil
    self.description          = nil
    self.description_sections = %w(description)
    self.email                = []
    self.extra_deps           = []
    self.extra_dev_deps       = []
    self.extra_rdoc_files     = []
    self.history_file         = "History.txt"
    self.post_install_message = nil
    self.readme_file          = "README.txt"
    self.rubyforge_name       = name.downcase
    self.spec                 = nil
    self.spec_extras          = {}
    self.summary              = nil
    self.summary_sentences    = 1
    self.test_globs           = ['test/**/test_*.rb']
    self.url                  = nil

    if block_given? then
      warn "Hoe.new {...} deprecated. Switch to Hoe.spec."
      self.activate_plugins
      yield self
      post_initialize
    end
  end

  ##
  # Intuit values from the readme and history files.

  def intuit_values
    readme = File.read(readme_file).split(/^(=+ .*)$/)[1..-1] rescue ''
    unless readme.empty? then
      sections = readme.map { |s|
        s =~ /^=/ ? s.strip.downcase.chomp(':').split.last : s.strip
      }
      sections = Hash[*sections]
      desc     = sections.values_at(*description_sections).join("\n\n")
      summ     = desc.split(/\.\s+/).first(summary_sentences).join(". ")

      self.description ||= desc
      self.summary     ||= summ
      self.url         ||= readme[1].gsub(/^\* /, '').split(/\n/).grep(/\S+/)
    else
      missing readme_file
    end

    self.changes ||= begin
                       h = File.read(history_file)
                       h.split(/^(===.*)/)[1..2].join.strip
                     rescue
                       missing history_file
                       ''
                     end
  end

  ##
  # Load activated plugins by calling their define tasks method.

  def load_plugin_tasks
    self.class.plugins.each do |plugin|
      send "define_#{plugin}_tasks"
    end
  end

  ##
  # Bitch about a file that is missing data or unparsable for intuiting values.

  def missing name
    warn "** #{name} is missing or in the wrong format for auto-intuiting."
    warn "   run `sow blah` and look at its text files"
  end

  ##
  # Normalize the dependencies.

  def normalize_deps deps
    Array(deps).map { |o| String === o ? [o] : o }
  end

  ##
  # Reads a file at +path+ and spits out an array of the +paragraphs+ specified.
  #
  #   changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
  #   summary, *description = p.paragraphs_of('README.txt', 3, 3..8)

  def paragraphs_of path, *paragraphs
    File.read(path).delete("\r").split(/\n\n+/).values_at(*paragraphs)
  end

  ##
  # Tell the world you're a pluggable package (ie you require rubygems 1.3.1+)

  def pluggable!
    abort "update rubygems to >= 1.3.1" unless  Gem.respond_to? :find_files
    spec_extras[:required_rubygems_version] = '>= 1.3.1'
  end

  ##
  # Finalize configuration

  def post_initialize
    intuit_values
    validate_fields
    add_dependencies
    define_spec
    load_plugin_tasks
  end

  ##
  # Provide a linear degrading value from n to m over start to finis dates.

  def timebomb n, m, finis = '2010-04-01', start = '2009-03-14'
    finis = Time.parse finis
    start = Time.parse start
    rest  = (finis - Time.now)
    full  = (finis - start)

    ((n - m) * rest / full).to_i + m
  end

  ##
  # Verify that mandatory fields are set.

  def validate_fields
    %w(email author).each do |field|
      value = self.send(field)
      abort "Hoe #{field} value not set. aborting" if value.nil? or value.empty?
    end
  end

  ##
  # Load or create a default config and yield it

  def with_config # :nodoc:
    rc = File.expand_path("~/.hoerc")
    exists = File.exist? rc
    config = exists ? YAML.load_file(rc) : {}
    yield(config, rc)
  end

  Hoe.load_plugins
end
