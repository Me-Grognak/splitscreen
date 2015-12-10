class ApplicationController < Sinatra::Base

  require "bundler"
  require 'SecureRandom'
  require 'http'
  require 'json'
  require 'dotenv'
  require 'date'
  Bundler.require

  Dotenv.load

  enable :sessions

  def set_user(user_name)
    session[:user] = user_name
  end

  def set_message(message)
    session[:message] = message
    # <%= session[:message] %>
  end

  def set_logged(logged)
    session[:logged] = logged
  end

  def set_signup(signup)
    session[:signup] = signup
  end

  def set_steam(steam_id)
    session[:steam_id] = steam_id
  end

  def resets
    session[:message] = nil
    session[:logged] = nil
    session[:signup] = nil
  end

  def get_SteamProfile(userid)
    return JSON.parse(HTTP.get("http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=94663FA38B7B685EE17033E7F15DEB48&steamids=" + userid.to_s))
    ENV['steam_api_key']

  end

  ActiveRecord::Base.establish_connection(
    :adapter => "postgresql",
    :database => "splitscreen"
  )

  set :views, File.expand_path("../../views", __FILE__)
  set :public_dir, File.expand_path("../../public", __FILE__)

  not_found do
    erb :page_not_found
  end

  def does_user_exist(username)
    user = Account.find_by(user_name: username)
    if user
      return true
    else
      return false
    end
  end

  def does_image_exist(filename)
    image = Account_Image.find_by(file_name: filename)
    if image
      return true
    else
      return false
    end
  end

  def authorization_check()
    if session[:current_user] == nil
      return false
    else
      return true
    end
  end

end
