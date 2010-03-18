class AdminController < ApplicationController
  
  before_filter :login_required

  # displays pages
  def index
    @admin = true
    @templates = Template.all
    @variants = Variant.find_all_by_template_id(@current_site.variant.template.id)
    @part_types = PartType.all
  end
  
  # displays user account info
  def account
    
  end
  
  ### Ajax methods
  def open_admin
    session[:showing_admin] = true
    session[:showing_section] = params[:id]
    render :nothing => true
  end
  
  def close_admin
    session[:showing_admin] = false
    session[:showing_section] = nil
    render :nothing => true
  end
  
  def change_template
    
  end
  
  def change_variant
    if params[:id]
      variant = Variant.find(params[:id])
      @current_site.update_attributes(:variant => variant)
      render :text => "/stylesheets/templates/#{variant.template.stylesheets}/#{variant.stylesheet}.css"
    end
  end
  
  
  # Add a page to a site. This action returns the URL of the new page so we can go there
  def add_page
    if params[:new_page_name]
      new_page = Page.new(:name => params[:new_page_name], :title => params[:new_page_name], :position => @current_site.pages.size + 1)
      @current_site.pages << new_page
      # TODO: Change this to return the location of the page in a header, not the body
      render :text => url_for(:controller => 'admin', :action => 'index', :page => new_page.slug, :only_path => true)
    else
      render :nothing => true, :status => 400
    end
  end
  
  def edit_page
    
  end
  
  def delete_page
    
  end
  
  def add_part
    if params[:id] && params[:part_type_id]
      page = Page.find(params[:id])
      part_type = PartType.find(params[:part_type_id])
      new_part = page.parts.create(:part_type_id => params[:part_type_id], :content => part_type.code)
      render :partial => "parts/#{new_part.part_type.class_name}", :locals => { :part => new_part, :mode => :edit, :text_selected => true }
    else
      render :nothing => true, :status => 400
    end
  end
  
  def edit_part
    if params[:part][:content]
      part = Part.find(params[:id])
      logger.debug(part.inspect)
      part.update_attributes(params[:part])
      render :partial => "parts/#{part.part_type.class_name}", :locals => { :part => part, :mode => :view }
    else
      render :nothing => true, :status => 400
    end
  end
    
  def delete_part
    if request.delete?
      Part.destroy(params[:id])
      render :nothing => true
    else
      render :nothing => true, :status => 400
    end
  end
  
  
end
