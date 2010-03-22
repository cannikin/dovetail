class User < ActiveRecord::Base
  
  has_many :ownerships
  has_many :sites, :through => :ownerships
  belongs_to :state
  belongs_to :country
  
  validates_presence_of :first_name, :last_name, :email, :login, :password
  validates_uniqueness_of :email, :message => "has already been taken. If you already have an account you can create more sites by logging in and going to the \"Account\" section at the top of the page"
  validates_uniqueness_of :login, :message => "has already been taken, please try again!"
  validates_length_of :password, :minimum => 5
  
  before_create :generate_uuid
  
  def name
    self.first_name + ' ' + self.last_name
  end
  
  # Determines whether or not this user owns the given site
  def owns(site)
    logger.debug("User #{self.login} owns site #{site.name}? #{self.sites.include?(site)}")
    self.sites.include?(site)
  end
  
  private
  
    def generate_uuid
      self.uuid = UUID.new.generate
    end
    
end
