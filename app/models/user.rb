class User < ActiveRecord::Base
  
  has_many :ownerships
  has_many :sites, :through => :ownerships
  belongs_to :state
  belongs_to :country
  
  validates_presence_of :first_name, :last_name, :email, :login, :password
  
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
