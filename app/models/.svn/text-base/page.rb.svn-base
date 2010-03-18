class Page < ActiveRecord::Base
  
  RESERVED = ['login','logout','session','admin']
  
  belongs_to :site
  has_many :parts
  
  before_save :make_slug
  
  validates_format_of :slug, :with => /^[A-Za-z0-9\-_]+$/, :message => 'Your page slug can only contain letters, numbers, -dashes- and _underscores_.', :allow_blank => true
  validates_uniqueness_of :slug, :case_sensitive => false, :scope => :site_id
  validates_exclusion_of :slug, :in => RESERVED, :message => "The name <strong>{{value}}</strong> is reserved for administrative use and unavailable for pages, please choose another name!"
  
  default_scope :conditions => { :visible => true }, :order => 'position'
  
  INDEX = 'index'
  
  # returns a default 'welcome' page
  def self.welcome_page(site)
    page = Page.new(:name => 'Home', :title => "Welcome to my site!", :position => site.pages.size + 1, :slug => INDEX)
    page.parts << Part.new(:part_type => PartType.default.first, :content => "h1. Welcome to my site!\n\nI just started building my site but check back soon!")
    return page
  end
  
  private
  
    def make_slug
      self.slug = self.name.parameterize.wrapped_string if self.slug.nil?
    end
    
end
