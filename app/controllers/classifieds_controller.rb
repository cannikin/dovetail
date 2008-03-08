class ClassifiedsController < ApplicationController

  before_filter :get_categories

  def index

  end
  
  def show
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
    end
  end
  
end
