require 'active_record'

options =
{
   adapter: 'postgresql',
   database: 'foodtracker'
}

ActiveRecord::Base.establish_connection(options)
