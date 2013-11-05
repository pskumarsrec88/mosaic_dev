class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def authentication
    redirect_to "/users/auth/facebook" unless user_signed_in?
  end
  
  def after_sign_in_path_for(resource_or_scope)
    new_photo_path
  end
  
end
