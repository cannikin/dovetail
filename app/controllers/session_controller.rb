class SessionController < ApplicationController
  
  def new
    @page_title = "Login"
    
    if logged_in?
      logger.debug("Redirecting to homepage, already logged in")
      redirect_to :controller => 'admin', :page => 'index'
    end
    
    # if this person has a cookie, auto-log them in when they click 'login'
    if cookies[:remember]
      if user = User.find_by_uuid(cookies[:remember])
        logger.debug("Loggin in user #{user.id} based on remember cookie")
        log_in_user(user)
      end
    end
  end

  def create
    @page_title = "Login"
    
    unless params[:session][:login].blank? || params[:session][:password].blank?
      logger.debug("Login: #{params[:session][:login]}, Password: #{params[:session][:password]}")
      if user = User.find_by_login_and_password(params[:session][:login], params[:session][:password])
        if Ownership.find_by_user_id_and_site_id(user.id, @current_site.id)
          cookies[:remember] = { :expires => 10.years.from_now, :value => user.uuid } if params[:session][:remember_me] == '1'  # save the user's uuid to a cookie if they want to be remembered
          logger.debug("Logging in user #{user.id} based on login/password")
          log_in_user(user)
        else
          flash.now[:notice] = 'Your login or password was incorrect, please try again.'
          render :new
        end
      else
        flash.now[:notice] = 'Your login or password was incorrect, please try again.'
        render :new
      end
    else
      flash[:notice] = 'Please enter both a login and password'
      render :new
    end
  end

  def destroy
    flash[:notice] = 'You have been logged out!'
    log_out_user
  end
  
  # forgot password
  def forgot
    
  end

end
