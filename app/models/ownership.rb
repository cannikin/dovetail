class Ownership < ActiveRecord::Base
  belongs_to :user
  belongs_to :site
end
