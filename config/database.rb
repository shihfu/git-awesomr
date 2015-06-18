require 'pg'  # gem install pg    Postgres gem
require 'pry'
require 'active_record'

# configure do
#   # Log queries to STDOUT in development
#   if Sinatra::Application.development?
#     ActiveRecord::Base.logger = Logger.new(STDOUT)
#   end

  # set :database, {
  #   adapter: "sqlite3",
  #   database: "db/db.sqlite3"
  # }

# Output messages from Active Record to standard out
ActiveRecord::Base.logger = Logger.new(STDOUT)

puts 'Establishing connection to database ...'
ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  database: 'gitclout',
  username: 'development',
  password: 'development',
  host: 'localhost',
  port: 5432,
  pool: 5,
  encoding: 'unicode',
  min_messages: 'error'
)
puts 'CONNECTED'


  # Load all models from app/models, using autoload instead of require
  # See http://www.rubyinside.com/ruby-techniques-revealed-autoload-1652.html
  Dir[APP_ROOT.join('app', 'models', '*.rb')].each do |model_file|
    filename = File.basename(model_file).gsub('.rb', '')
    autoload ActiveSupport::Inflector.camelize(filename), model_file
  end

# end
