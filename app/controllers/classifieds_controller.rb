class ClassifiedsController < ApplicationController

  before_filter :get_categories
  
  def index
    if params[:subcategory]
      @category = Category.find_by_full_url(params)
      @ads = @category.ads
    elsif params[:category]
      # find all ads by the children of this category
      @category = Category.find_by_url(params[:category], :conditions => 'parent_id is null')
      category_ids = @category.children.collect do |cat|
        cat.id
      end
      # append the parent category itself
      category_ids << @category.id
      @ads = Ad.find_all_by_category_id(category_ids, :order => 'created_at desc')
    end
  end
  
end
