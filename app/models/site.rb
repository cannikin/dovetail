class Site < ActiveRecord::Base
  
  RESERVED = ['','signup','support','blog','www','billing','help','api','forums']
  
  has_one :ownership
  has_one :owner, :through => :ownership, :source => :user
  has_many :pages
  belongs_to :variant
  
  validates_presence_of :name, :message => '- Your site name cannot be blank'
  validates_presence_of :subdomain
  validates_format_of :subdomain, :with => /^[A-Za-z0-9-]+$/, :message => '- Your subdomain can only contain letters, numbers and dashes.', :allow_blank => true
  validates_uniqueness_of :subdomain, :case_sensitive => false
  validates_exclusion_of :subdomain, :in => RESERVED, :message => "- The subdomain \"{{value}}\" is reserved and unavailable."
  
  default_scope :conditions => { :enabled => true }
  # named_scope :enabled, :conditions => { :enabled => true }
  
  # Was there a reason to make this before_validation instead of before_create?
  # before_validation :downcase_subdomain
  before_create :downcase_subdomain, :assign_default_template, :add_welcome_page

  private
  
    # makes sure that the subdomain is always stored in all lowercase in the database
    def downcase_subdomain
      self.subdomain.downcase! if attribute_present?('subdomain')
    end
    
    # assigns the default template
    def assign_default_template
      self.variant ||= Variant.default.first
    end
  
    # adds the default welcome page
    def add_welcome_page
      self.pages << Page.welcome_page(self)
    end
    
end
