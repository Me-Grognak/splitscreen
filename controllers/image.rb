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
  pic.title = params[:title] || 'untitled'
  pic.save

  File.open('public/uploads/images/' + filepath, 'w') do |f|
    f.write(params['pic'][:tempfile].read)
  end

  redirect "/"
end
#-------------------------------------------------------------------------------

get '/more' do #sends additional pictures upon ajax request
  total = params.to_hash['total'].to_i
  max = Account_Image.all.length - total
  min = max - 11 #12
  if min < 0 && max < 0
    return {:done => true}.to_json
  else
    sleep 0.3
    return Account_Image.where(:id => min..max).reverse.to_json
  end
end


get '/:id' do
  image = Account_Image.find_by(id: params[:id])
  if authorization_check
    @check = Image_Like.find_by(image_id: params[:id], user_name: session[:current_user].user_name)
  end
  if image
    @image = image
    @comments = Image_Comment.where(image_id: params[:id])
    image.views += 1
    image.save
    return erb :image
  else
    return 'Page does not exist!'
  end
end


post '/comment' do
  if authorization_check
    options = params.to_hash
    new_comment = Image_Comment.new
    new_comment.account_id = session[:current_user].id
    new_comment.user_name = session[:current_user].user_name
    new_comment.border = options['border']
    new_comment.color = options['color']
    new_comment.image_id = options['image']
    new_comment.comment = options['text']
    new_comment.pos_x = options['posx']
    new_comment.pos_y = options['posy']
    new_comment.save
  else
    print "user not logged in!"
  end
end

post '/liked' do
  if authorization_check
    check = Image_Like.find_by(image_id: params[:id], user_name: session[:current_user].user_name)
    if !check
      image = Account_Image.find_by(id: params[:id])
      image.likes += 1
      image.save
      like = Image_Like.new
      like.image_id = params[:id]
      like.user_name = session[:current_user].user_name
      like.save
    end
  else
    print "user not logged in!"
  end
end


end
