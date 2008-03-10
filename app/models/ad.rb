class Ad < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :category
  has_many   :images
  
end
