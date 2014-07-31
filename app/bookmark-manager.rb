require 'sinatra'
require 'data_mapper'
require 'database_cleaner'
require 'rack-flash'
require 'rest-client'
require_relative 'models/user'
require_relative 'models/tag'
require_relative 'models/link'
require_relative 'data_mapper_setup'
require_relative 'controllers/application'
require_relative 'controllers/links'
require_relative 'controllers/users'
require_relative 'controllers/sessions'
require_relative 'controllers/tags'
require_relative 'helpers/application'

enable :sessions
set :session_secret, 'super secret'
use Rack::Flash
set :public_dir, Proc.new {File.join(root, "..", "public")}



