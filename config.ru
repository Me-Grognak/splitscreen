require "sinatra/base"

require "./controllers/application"
require "./controllers/account"
require "./models/account"

require "./controllers/image"
require "./models/image"


map("/") { run AccountController }
map("/image") { run ImageController }
