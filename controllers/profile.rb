class ProfileController < ApplicationController

  get "/:user_name" do
    if authorization_check()
      if params[:user_name] == session[:current_user].user_name
        @user_name = session[:current_user].user_name
        p @id = session[:current_user].id
        p comment = Comment.where(account_id: session[:current_user].id)
        p @comments = comment.reverse
        erb :profile
      else
        erb :not_authorized
      end
    else
      erb :not_authorized
    end
  end

  post "/:user_name" do

    # binding.pry
    #params info sent

    new_comment = Comment.new(account_id: params[:account_id], comment: params[:comment])
    new_comment.save

    redirect "/profile/" + session[:current_user].user_name

  end
end
