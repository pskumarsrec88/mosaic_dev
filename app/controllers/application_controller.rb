class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def authentication
    unless user_signed_in?
      redirect_to "/users/auth/facebook"
    end
  end
  
end
