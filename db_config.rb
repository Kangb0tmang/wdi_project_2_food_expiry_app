require 'active_record'

options = {
  adapter: 'postgresql',
  database: 'foodtracker'
}

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || options)
