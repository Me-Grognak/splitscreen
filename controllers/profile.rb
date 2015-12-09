class ProfileController < ApplicationController

  get "/user/:user_name" do
    @user_name = params[:user_name]
    user = Account.find_by(user_name: @user_name)
    @id = user.id
    comment = Comment.where(account_id: @id)
    @comments = comment.reverse

    erb :profile
  end

#----------------------- For Posting Comments ---------------------------------#

  post "/user/:user_name" do

    new_comment = Comment.new(account_id: params[:account_id], comment: params[:comment])
    new_comment.save

    redirect "/profile/user/" + params[:user_name]
  end
#------------------------------------------------------------------------------#
#---------------------- AJAX profile properties -------------------------------#

  get "/:user_name/profile_props" do
    user = Account.find_by(user_name: params[:user_name])

    @user_name = user.user_name
    @id = user.id
    p @user_profile = Profile.where(account_id: @id)
    status 200
    return @user_profile.to_json
  end

#------------------------------------------------------------------------------#

  get "/edit_profile/:user_name" do
    if authorization_check && session[:current_user].user_name == params[:user_name]
      p @id = session[:current_user].id
      p @user_name = session[:current_user].user_name
      erb :edit_profile
    else
      erb :not_authorized
    end
  end

#------------------------ Profile Editing Submissions -------------------------#
  post "/edit_profile/:user_name" do

    profile = Profile.new(account_id: params[:account_id], location: params[:location], pc: params[:pc], ps4: params[:ps4], xbo: params[:xbo], wiiu: params[:wiiu], ps3: params[:ps3], xb360: params[:xb360], wii: params[:wii], steam_id: params[:steam_tag], psn_id: params[:psn_tag], xbl_id: params[:xbl_tag]);
    profile.save

    p profile
    redirect "/:user_name"
  end
#------------------------------------------------------------------------------#

end
