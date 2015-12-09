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


  get "/edit_profile/:user_name" do
    p @id = session[:current_user].id
    p @user_name = session[:current_user].user_name
    erb :edit_profile
  end

  post "/edit_profile/:user_name" do

    new_profile = Profile.new(account_id: params[:account_id], location: params[:location], pc: params[:pc], ps4: params[:ps4], xbo: params[:xbo], wiiu: params[:wiiu], ps3: params[:ps3], xb360: params[:xb360], wii: params[:wii], steam_id: params[:steam_tag], psn_id: params[:psn_tag], xbl_id: params[:xbl_tag]);
    new_profile.save

    p new_profile
    redirect "/:user_name"
  end
end
