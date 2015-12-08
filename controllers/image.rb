class ImageController < ApplicationController

#-------------------------------------------------------------------------------
post '/upload' do
  if !authorization_check()
    @message = "You need to be logged in to upload images!"
    return erb :upload
  end
  ext = File.extname(params["pic"][:filename])
  hex = SecureRandom.hex
  filepath = hex + ext

  #base = Base64.encode64(open(params["pic"][:tempfile]) { |io| io.read})
  pic = Account_Image.new
  pic.image_path = filepath
  pic.user_name = session[:current_user].user_name
  pic.title = params[:title]
  pic.save

  File.open('public/uploads/images/' + filepath, 'w') do |f|
    f.write(params['pic'][:tempfile].read)
  end

  redirect "/"
end
#-------------------------------------------------------------------------------

end
