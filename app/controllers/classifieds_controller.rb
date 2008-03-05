class ClassifiedsController < ApplicationController

  def index
    if params[:subcategory]
      # find all ads for this subcategory
      category = Category.find_by_sql(  "select child.* " +
                                        "from   categories child inner join categories parent on child.parent_id = parent.id " +
                                        "where  child.url = '#{params[:subcategory]}' and parent.url = '#{params[:category]}'" +
                                        "order by child.created_at asc")
      @ads = Ad.find_all_by_category_id(category, :order => 'created_at desc')
    elsif params[:category]
      # find all ads by the children of this category
      category = Category.find_by_url(params[:category], :conditions => 'parent_id is null')
      categories = category.children.collect do |cat|
        cat.id
      end
      categories << category.id
      @ads = Ad.find_all_by_category_id(categories, :order => 'created_at desc')
    else
      # just a list of all categories
      @categories = Category.find_roots
    end
  end
  
  def show
    @ad = Ad.find(params[:id])
  end
  
end
