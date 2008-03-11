class Ad < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :category
  has_many   :images
  
  def has_images?
    !self.images.empty?
  end

end
