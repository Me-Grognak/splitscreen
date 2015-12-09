class AccountController < ApplicationController

  get "/" do
    self.resets
    if authorization_check()
      self.set_logged("block")
      self.set_signup("none")
    end
    @images = Account_Image.last(12).reverse
    erb :index
  end


#Register "GET"-----------------------------------------------------------------
  get "/register" do
    self.resets
    if authorization_check()
      self.set_logged("block")
    end
    erb :register
  end
#-------------------------------------------------------------------------------



#Register "POST"----------------------------------------------------------------
  post "/register" do

    if does_user_exist(params[:user_name]) == true
      self.set_message("Uh Oh! This user already exists.")
      return erb :register
    end

    if params[:password] != params[:confirm_password]
      self.set_message("Please confirm that your passwords match.")
      return erb :register
    end

    new_user = Account.new(user_name: params[:user_name], user_email: params[:user_email], password: params[:password])
    new_user.save

    p new_user

    session[:current_user] = new_user
    self.set_logged("block")
    erb :register_success

  end
#-------------------------------------------------------------------------------



#Login "GET"--------------------------------------------------------------------
  get "/login" do
    self.resets
    if authorization_check()
      self.set_logged("block")
      self.set_signup("none")
    end
    erb :login
  end
#-------------------------------------------------------------------------------



#Login "POST"-------------------------------------------------------------------
  post "/login" do
    if session[:current_user]
      self.set_message("You are already logged in")
      self.set_logged("block")
      erb :login
    elsif does_user_exist(params[:user_name])
      user = Account.authenticate(params[:user_name], params[:password])

      if user
        session[:current_user] = user
        self.set_message("Welcome back, " + params[:user_name])
        self.set_logged("block")
        self.set_signup("none")
        redirect "/profile/" + params[:user_name]
      else
        self.set_message("Invalid username or password")
        erb :login
      end

    else
      self.set_message("Invalid username or password")
      erb :login
    end

  end
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
  get "/logout" do
    if authorization_check()
      self.set_message("You are not currently logged in")
    end
    self.set_message("You have successfully logged out")
    self.set_logged("none")
    self.set_signup("inline-block")
    session[:current_user] = nil
    erb :logout
  end
#-------------------------------------------------------------------------------


#Upload "GET"-----------------------------------------------------------------
  get "/upload" do
    erb :upload
  end
#-------------------------------------------------------------------------------

end
