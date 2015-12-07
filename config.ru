require "sinatra/base"

require "./controllers/application"
require "./controllers/account"
require "./controllers/profile"
require "./models/account"
require "./models/profile"

map("/") { run AccountController }
map("/profile") { run ProfileController }
