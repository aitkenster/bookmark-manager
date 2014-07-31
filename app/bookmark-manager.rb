require 'sinatra'
require 'data_mapper'
require 'database_cleaner'
require 'rack-flash'
require 'rest-client'
require_relative 'data_mapper_setup'
require './lib/user'
require './lib/tag'
require './lib/link'
require_relative 'controllers/application'
require_relative 'controllers/links'
require_relative 'controllers/users'
require_relative 'controllers/sessions'
require_relative 'controllers/tags'
require_relative 'helpers/application'

enable :sessions
set :session_secret, 'super secret'
use Rack::Flash



