# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  helper :all # include all helpers, all the time
  # protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :get_current_site, :get_page_or_404, :get_current_user
  helper_method :logged_in?
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  private
  
    # gets the current site based on subdomain
    def get_current_site
      @current_site = Site.find_by_subdomain(site_subdomain, :include => { :variant => :template })
      logger.debug("*** Site Found: #{@current_site.inspect}")
    end
    
    def get_current_user
      if logged_in?
        @current_user = User.find(session[:user_id])
      end
    end
    
    def get_page_or_404
      if Site::RESERVED.include? site_subdomain
        # this is a special subdomain like 'api' so don't do all the normal user site lookup stuff
      elsif @current_site
        if params[:controller] == 'main' || params[:controller] == 'admin'
          unless @page = get_page(@current_site, params[:page])
            render_404 and return
          end
        end
      else
        render("#{RAILS_ROOT}/public/site_not_found.html", :status => 404) and return
      end
    end

    # Gets the page to show for the given site and URL
    def get_page(site,page)
      page.blank? ? Page.find_by_slug_and_site_id(Page::INDEX, site.id, :include => { :parts => :part_type }) : Page.find_by_slug_and_site_id(page, site.id, :include => { :parts => :part_type} )
    end
    
    def login_required
      redirect_to login_path unless logged_in?
    end
    
    # shows the 404 page
    def render_404
      render("#{RAILS_ROOT}/public/404.html", :status => 404)
    end
    
    # log a user in
    def log_in_user(user)
      session[:user_id] = user.id
      session[:admin_open] = false
      redirect_to admin_path(:page => 'index')
    end
    
    # log out
    def log_out_user
      session[:user_id] = nil
      session[:admin_open] = nil
      redirect_back
    end
    
    # is this person logged in?
    def logged_in?
      !session[:user_id].nil? #&& User.find(session[:user_id]).owns(@current_site)
    end
    
    # is this a user site?
    def user_site?
      !Site::RESERVED.include? site_subdomain
    end
  
    # is this an internal site?
    def internal_site?
      Site::RESERVED.include? site_subdomain
    end
  
    def site_url(use_ssl=request.ssl?)
      http_protocol(use_ssl) + site_host(site_subdomain)
    end

    def site_host(subdomain)
      site_host = ''
      site_host << subdomain + '.'
      site_host << site_domain
    end

    def site_domain
      site_domain = ''
      site_domain << request.domain + request.port_string
    end
  
    def site_subdomain
      request.subdomains.first || ''
    end
  
    def http_protocol(use_ssl=request.ssl?)
      (use_ssl ? "https://" : "http://")
    end
    
    # if there's a return_to value in session, use that to redirect the user back to a page (most useful 
    # when someone tries to access a page that requires login, we can send them right back to it after logging in)
    def redirect_back
      send_to = session[:return_to]
      session[:return_to] = nil
      redirect_to(send_to || root_path)
    end
  
end
