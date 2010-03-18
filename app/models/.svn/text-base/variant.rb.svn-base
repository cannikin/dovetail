class Variant < ActiveRecord::Base
  
  belongs_to :template
  
  default_scope :order => 'position'
  named_scope :default, :conditions => { :default => true }
  
  
  # returns the URL to a thumbnail image of this variant
  def thumbnail
    "template_" + self.template.stylesheets + "_" + self.stylesheet + ".png"
  end
  
end
