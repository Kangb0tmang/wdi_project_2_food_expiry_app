require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'pry'

require_relative 'db_config'
require_relative 'models/fridge_item'
require_relative 'models/guide'
require_relative 'models/user'

enable :sessions

helpers do
   def current_user
      User.find_by(id: session[:user_id])
   end

   def logged_in?
      !!current_user
   end
end

# Login/Logout
get '/login' do
   session[:user_id] = User.first.id
   redirect '/food'
end

get '/' do
   erb :index
end

get '/about' do
  erb :about
end

get '/food' do
  erb :food
end

get '/food/:storage_type' do
   params[:storage_type]
   erb :storage
end

# Create
get '/food/fridge/new' do
  erb :new
end

post '/food/:storage_type' do
   # current_user.id
   Food.new(user: current_user)
   # binding.pry
   redirect "/food/#{params[:storage_type]}"
end

get '/food/fridge/edit' do
  erb :edit
end

get '/food/fridge/delete' do
  erb :delete
end

get '/guide' do
  erb :guide
end
