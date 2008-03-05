class ClassifiedsController < ApplicationController

  def index
    if params[:subcategory]
      @category = Category.find_by_full_url(params)
      @ads = @category.ads
      @breadcrumbs = [ { :name => @category.parent.name, :url => url_for(:category => @category.parent.url, :subcategory => nil) },
                       { :name => @category.name, :url => url_for(:category => @category.parent.url, :subcategory => @category.url) } ]
    elsif params[:category]
      # find all ads by the children of this category
      @category = Category.find_by_url(params[:category], :conditions => 'parent_id is null')
      category_ids = @category.children.collect do |cat|
        cat.id
      end
      # append the parent category itself
      category_ids << @category.id
      @ads = Ad.find_all_by_category_id(category_ids, :order => 'created_at desc')
      @breadcrumbs = [ { :name => @category.name, :url => url_for(:category => @category.url, :subcategory => nil) } ]
    else
      # just a list of all categories
      @categories = Category.find_all_roots
    end
  end
  
  def show
    @ad = Ad.find(params[:id])
  end
  
end
