class MainController < ApplicationController
  
  before_filter :auto_login
  
  def index
  end
  
  private
    
    # Looks to see if we should automatically log this user in.
    # This is used when someone creates their site for the first time, we bring them to their homepage
    # and log them in automatically by using their UUID
    def auto_login
      if params[:token]
        user = User.find_by_uuid(params[:token])
        log_in_user(user)
      end
    end

end
