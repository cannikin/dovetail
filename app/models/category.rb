class Category < ActiveRecord::Base
  
  acts_as_tree :order => 'name'
  has_many :ads
  
  # only finds the root categories (those with no parent)
  def self.find_all_roots
    find(:all, :conditions => 'parent_id is null')
  end

  # find a specific category by the full URL
  def self.find_by_full_url(params)
    category = Category.find_by_sql(  "select   child.id " +
                                      "from     categories child inner join categories parent on child.parent_id = parent.id " +
                                      "where    child.url = '#{params[:subcategory]}' and parent.url = '#{params[:category]}'" +
                                      "order by child.created_at asc")
    # do a regular ActiveRecord find so that we have a normal ActiveRecord object
    Category.find(category).first
  end
  
  # set the url for this category automatically before it's saved
  def before_save
    self.url = self.name.downcase.gsub(/ /, '_').gsub(/[^A-Za-z0-9_]/, '')
  end
  
end
