class ApplicationController < Sinatra::Base

  require "bundler"
  require 'SecureRandom'
  Bundler.require

  require "date"

  enable :sessions

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

  def resets
    session[:message] = nil
    session[:logged] = nil
    session[:signup] = nil
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
