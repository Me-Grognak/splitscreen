class ApplicationController < Sinatra::Base

  require "bundler"
  Bundler.require

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

  # def get_message
  #   return @message
  # end
  #
  # def get_logged
  #   return @logged
  # end
  #
  # def get_signup
  #   return @signup
  # end
  # @@message = "Default"
  # @@logged = "none"
  # @@signup = "block"

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

  def authorization_check()
    if session[:current_user] == nil
      return false
      # redirect "/not_authorized"
    else
      return true
    end
  end

end
