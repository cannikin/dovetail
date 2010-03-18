ActionController::Routing::Routes.draw do |map|
  
  #map.namespace :api do |api|
  #  api.resources :sites
  # api.resources :ownerships
  # api.resources :templates
  # api.resources :part_types
  # api.resources :parts
  # api.resources :pages
  # api.resources :users
  #end
  
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end
  
  map.connect 'login/create', :controller => 'session', :action => 'create'
  map.connect 'login/forgot', :controller => 'session', :action => 'forgot'
  map.login 'login', :controller => 'session', :action => 'new'
  map.logout 'logout', :controller => 'session', :action => 'destroy'

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  
  # user's account page
  map.account 'admin/account', :controller => 'admin', :action => 'account'
  map.ajax 'admin/ajax/:action/:id', :controller => 'admin'
  
  # when administrating your page, you go to /admin instead of just / to view your pages
  map.admin 'admin/index', :controller => 'admin', :action => 'index', :page => 'index'
  map.connect 'admin/:page', :controller => 'admin', :action => 'index'
  map.connect 'admin', :controller => 'admin', :action => 'index', :page => 'index'
  # map.admin 'admin', :controller => 'admin', :page => 'index'
    
  # all requests are for site pages, these are only ever one level deep (we should be able to cache these)
  map.connect ':page', :controller => 'main'
  
  # we move the mapping for sites down here so that if we're accessing the site with a normal user's 
  # subdomain (rob.websitesforwoodworkers.com) they default application logic will kick in, not find a
  # page named "sites" and throw a 404
  # Accessing through api.websitesforwoodworkers.com skips all that logic and this route should match
  map.resources :sites
  map.resources :users
  map.resources :ownerships
  
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "main"
  
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
