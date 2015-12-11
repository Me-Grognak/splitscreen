class ProfileController < ApplicationController

  get "/user/:user_name" do
    if !does_user_exist(params[:user_name])
      erb :page_not_found
    else
      @user_name = params[:user_name]
      user = Account.find_by(user_name: @user_name)
      @id = user.id
      if session[:current_user] != nil
        @poster_id = session[:current_user].id
        @poster_name = session[:current_user].user_name
      end
      comment = Comment.where(account_id: @id)
      @comments = comment.reverse
      if !authorization_check || session[:current_user].user_name != params[:user_name]
        @no_edit = "none"
      end
      if session[:current_user] == nil
        @no_post = "none"
      end
      if does_user_exist(params[:user_name])
        @images = Account_Image.where(user_name: params[:user_name])
      end
      erb :profile
    end
  end

#----------------------- For Posting Comments ---------------------------------#

  post "/user/:user_name" do

    new_comment = Comment.new(account_id: params[:account_id], poster_name: params[:poster_name], comment: params[:comment])
    new_comment.save

    redirect "/profile/user/" + params[:user_name]
  end
#------------------------------------------------------------------------------#
#---------------------- AJAX profile properties -------------------------------#

  get "/:user_name/profile_props" do
    user = Account.find_by(user_name: params[:user_name])

    @user_name = user.user_name
    @id = user.id
    @user_profile = Profile.where(account_id: @id)
    set_steam(@user_profile[0].steam_id)
    return @user_profile.to_json
  end

  get "/steam" do
    @steam_api = get_SteamProfile(session[:steam_id]).to_json
    return @steam_api
  end

#------------------------------------------------------------------------------#

  get "/edit_profile/:user_name" do
    if authorization_check && session[:current_user].user_name == params[:user_name]
      p @id = session[:current_user].id
      p @user_name = session[:current_user].user_name
      @profile = Profile.find_by(account_id: @id)
      erb :edit_profile
    else
      erb :not_authorized
    end
  end

#------------------------ Profile Editing Submissions -------------------------#
  post "/edit_profile/:user_name" do

    # profile = Profile.new(account_id: params[:account_id], location: params[:location], pc: params[:pc], ps4: params[:ps4], xbo: params[:xbo], wiiu: params[:wiiu], ps3: params[:ps3], xb360: params[:xb360], wii: params[:wii], steam_id: params[:steam_tag], psn_id: params[:psn_tag], xbl_id: params[:xbl_tag]);
    profile = Profile.find_by(account_id: params[:account_id])
    profile.update(location: params[:location], pc: params[:pc], ps4: params[:ps4], xbo: params[:xbo], wiiu: params[:wiiu], ps3: params[:ps3], xb360: params[:xb360], wii: params[:wii], steam_id: params[:steam_tag], psn_id: params[:psn_tag], xbl_id: params[:xbl_tag])
    # profile.save

    p profile
    redirect "/profile/user/" + params[:user_name]
  end
#------------------------------------------------------------------------------#

get "/info" do
  min = params[:total].to_i
  max = min + 13
  total = Profile.all.length
  if min >= total
    return {:done => true}.to_json
  elsif
    data = {:type => 'profiles', :data =>  Profile.where(:id => min..max)}
    if params[:total].to_i != 0
      sleep 0.2
    end
    return data.to_json
  end
end
end
