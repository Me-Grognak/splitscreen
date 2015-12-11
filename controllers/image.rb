class ImageController < ApplicationController

#-------------------------------------------------------------------------------
post '/upload' do
  if !authorization_check()
    @message = "You need to be logged in to upload images!"
    return erb :upload
  end
  tags = params[:tags]
  user = session[:current_user].user_name

  ext = File.extname(params["pic"][:filename])
  hex = SecureRandom.hex
  filepath = hex + ext

  #base = Base64.encode64(open(params["pic"][:tempfile]) { |io| io.read})

  if params[:avatar]
    user_profile = Profile.find_by(user_name: user)
    user_profile.avatar_path = filepath
    user_profile.save
  else
    pic = Account_Image.new
    pic.tags = tags
    pic.image_path = filepath
    pic.user_name = user
    pic.title = params[:title] || 'untitled'
    pic.save
  end

  File.open('public/uploads/images/' + filepath, 'w') do |f|
    f.write(params['pic'][:tempfile].read)
  end

  redirect "/"
end
#-------------------------------------------------------------------------------

get '/more' do # sends additional pictures upon ajax request
  total = params.to_hash['total'].to_i
  max = Account_Image.all.length - total
  min = max - 11 #12
  p "min: #{min} max: #{max}"
  if min <= 0 && max <= 0
    return {:done => true}.to_json
  else
    data = {:type => 'images', :data => Account_Image.where(:id => min..max).reverse}
    if total != 0
      sleep 0.2
    end
    return data.to_json
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
