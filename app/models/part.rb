class Part < ActiveRecord::Base
  
  acts_as_list :scope => :page
  
  belongs_to :page, :touch => true
  belongs_to :part_type
  
  default_scope :conditions => { :visible => true }, :order => 'position'

end
