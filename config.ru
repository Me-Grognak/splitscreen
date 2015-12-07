require "sinatra/base"

require "./controllers/application"
require "./controllers/account"
require "./controllers/profile"
require "./models/account"
require "./models/profile"

require "./models/image"
require "./controllers/image"

map("/") { run AccountController }
map ("/image") { run ImageController }
map("/profile") { run ProfileController }
