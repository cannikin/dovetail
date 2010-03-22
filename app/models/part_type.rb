class PartType < ActiveRecord::Base
  
  has_many :parts
  
  validates_uniqueness_of :name, :class_name
  
  default_scope :conditions => { :enabled => true }
  named_scope :default, :conditions => { :default => true }
  
end
