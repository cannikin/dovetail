class Template < ActiveRecord::Base
  
  has_many :sites
  has_many :variants
  
  named_scope :default, :conditions => { :default => true }
  
  # returns the URL to a thumbnail image of this template
  def thumbnail
    "template_" + self.template.stylesheets + ".png"
  end
  
end
