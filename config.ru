require "sinatra/base"

require "./controllers/application"
require "./controllers/account"
require "./controllers/profile"
require "./models/account"
require "./models/profile"
require "./models/comment"
require "./models/image_comment"
require "./models/image_like"

require "./models/image"
require "./controllers/image"

map("/") { run AccountController }
map ("/images") { run ImageController }
map("/profile") { run ProfileController }
