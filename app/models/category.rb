class Category < ActiveRecord::Base
  
  acts_as_tree :order => 'name'
  has_many :ads
  
  # only finds the root categories (those with no parent)
  def self.find_roots
    find(:all, :conditions => 'parent_id is null')
  end
  
  # set the url for this category automatically before it's saved
  def before_save
    self.url = self.name.downcase.gsub(/ /, '_').gsub(/[^A-Za-z0-9_]/, '')
  end
  
end
