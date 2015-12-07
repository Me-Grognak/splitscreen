class ProfileController < ApplicationController

  get "/:user_name" do
    if authorization_check()
      if params[:user_name] == session[:current_user].user_name
        erb :profile
      else
        erb :not_authorized
      end
    else
      erb :not_authorized
    end
  end
end
