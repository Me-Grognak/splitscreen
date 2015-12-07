class ProfileController < ApplicationController

  get "/:user_name" do
    erb :profile
  end
end
