class PartType < ActiveRecord::Base
  
  has_many :parts
  
  validates_uniqueness_of :name, :class_name
  
  named_scope :default, :conditions => { :default => true }
  
end
