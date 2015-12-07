class ApplicationController < Sinatra::Base

  require "bundler"
  Bundler.require

  ActiveRecord::Base.establish_connection(
    :adapter => "postgresql",
    :database => "splitscreen"
  )

  set :views, File.expand_path("../../views", __FILE__)
  set :public_dir, File.expand_path("../../public", __FILE__)

  not_found do
    erb :page_not_found
  end

  enable :sessions

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
      # redirect "/not_authorized"
    else
      return true
    end
  end

end
