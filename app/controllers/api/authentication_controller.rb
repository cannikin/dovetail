class Api::AuthenticationController < ApplicationController
  
  USER_NAME = 'websites_for_woodworkers'
  PASSWORD = 'J3y$b6[sqL'
  
  before_filter :authenticate, :only => 'index'
  
  private
    # performs Basic HTTP authentication so that XML and JSON data can be requested without a session
    # If the user IS logged and they are an admin then they can get the data like normal
    def authenticate
      case request.format
      when Mime::XML, Mime::JSON
        unless logged_in? && admin?
          authenticate_or_request_with_http_basic do |user_name, password|
            user_name == USER_NAME && password == PASSWORD
          end
        end
      else
        render_404 and return unless logged_in? && admin?
      end
    end
  
end
