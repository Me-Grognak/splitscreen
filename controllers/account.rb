class AccountController < ApplicationController

  get "/" do
    if authorization_check()
      self.set_logged("block")
      self.set_signup("none")
    end
    @images = Account_Image.last(20).reverse
    erb :index
  end


#Register "GET"-----------------------------------------------------------------
  get "/register" do
    self.set_message(nil)
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

    new_profile = Profile.new(account_id: new_user.id, user_name: params[:user_name], location: nil, pc: nil, ps4: nil, xbo: nil, wiiu: nil, ps3: nil, xb360: nil, wii: nil, steam_id: nil, psn_id: nil, xbl_id: nil);

    new_profile.save

    p new_profile

    session[:current_user] = new_user
    self.set_logged("block")
    self.set_signup("none")
    self.set_user(session[:current_user].user_name)
    erb :register_success

  end
#-------------------------------------------------------------------------------



#Login "GET"--------------------------------------------------------------------
  get "/login" do
    self.set_message(nil)
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
        self.set_user(session[:current_user].user_name)
        redirect "/profile/user/" + params[:user_name]
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
    self.set_user(nil)
    session[:current_user] = nil
    erb :logout
  end
#-------------------------------------------------------------------------------


#Upload "GET"-----------------------------------------------------------------
  get "/upload" do
    erb :upload
  end
#-------------------------------------------------------------------------------

#Search Query "POST"-----------------------------------------------------------------
  post "/search" do
    search_query = params[:search]
    search_type = params[:type]
    data = {}
    if search_type == 'profiles'
      found_user = Profile.find_by(user_name: search_query)
      if found_user
        data = {:found => found_user}
        return data.to_json
      elsif
        related_users = Profile.where("user_name SIMILAR TO ?", "#{search_query}%").limit(16)
        data = {:type => 'profiles', :relations => related_users}
        return data.to_json
      end
    elsif search_type == 'images' # TO DO: Make tags have their own table to increase performance.
      images = Account_Image.all
      related_images = []
      images.each do |image|
        if !image.tags
          next
        end
        tags = image.tags.split(',')
        tags.each do |tag|
          check = /\b#{search_query}(.*)/.match(tag)
          if tag.to_s == check.to_s
            related_images.push(image)
            break
          end
        end
      end
      data = {:type => 'images', :relations => related_images}
      return data.to_json
    end
  end
#-------------------------------------------------------------------------------

end
