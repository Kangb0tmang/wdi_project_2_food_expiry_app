require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'pry'

require_relative 'db_config'
require_relative 'models/food_item'
require_relative 'models/guide'
require_relative 'models/storage_type'
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
   @message = ""
   erb :login
end

post '/session' do
   user = User.find_by(email: params[:email])

   if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/food'
   else
      @message = "Incorrect email or password"
      erb :login
   end
end

delete '/session' do
   session[:user_id] = nil
   redirect '/login'
end

# Create
get '/food/:storage_type/new' do
   unless logged_in?
      redirect '/login'
      @message = "Login first to add some food"
   else
      erb :new
   end
end

post '/food/:storage_type' do
   food = Food_Item.new
   food.item_name = params[:item_name]
   food.purchase_date = params[:purchase_date]
   food.expiry_date = params[:expiry_date]
   food.status = 'stored'
   food.notification = params[:notification]
   food.user_id = current_user.id
   @get_storage_type = Storage_Type.find_by(storage_name: params[:storage_type])
   food.storage_type_id = @get_storage_type.id
   food.save
   redirect "/food/#{params[:storage_type]}"
   # binding.pry
end

# Read
get '/' do
   erb :index
end

get '/about' do
  erb :about
end

get '/food' do
   unless logged_in?
      redirect '/login'
      @message = "Login first to add some food"
   else
      erb :food
   end
end

get '/food/:storage_type' do
   unless logged_in?
      @message = "Login first to add some food"
      redirect '/login'
   else
      get_storage_type_id = Storage_Type.find_by(storage_name: params[:storage_type]).id
      @all_food = Food_Item.all.where(storage_type_id: get_storage_type_id)
      erb :storage
   end
end

# Single Item view
get '/food/:storage_type/:id' do
   unless logged_in?
      @message = "Login first to add some food"
      redirect '/login'
   else
      @food_item = Food_Item.find(params[:id])
      erb :single
   end
end

# Update
get '/food/:storage_type/:id/edit' do
   unless logged_in?
      redirect '/login'
      @message = "Login first to add some food"
   else
      @food_item = Food_Item.find(params[:id])
      erb :edit
   end
end

put '/food/:storage_type/:id' do
   food = Food_Item.find(params[:id])
   food.item_name = params[:item_name]
   food.purchase_date = params[:purchase_date]
   food.expiry_date = params[:expiry_date]
   # if not past expiry date and checked
   #    status = 'consumed'
   # elsif not past expiry date and not checked
   #    status = 'active'
   # end
   # food.status = 'stored'
   food.notification = params[:notification]
   food.user_id = current_user.id
   get_storage_type = Storage_Type.find_by(storage_name: params[:storage_type])
   food.storage_type_id = get_storage_type.id
   food.save
   redirect "/food/#{params[:storage_type]}/#{params[:id]}"
end

# Delete
get '/food/:storage_type/:id/delete' do
   unless logged_in?
     redirect '/login'
     @message = "Login first to add some food"
   else
      @food_item = Food_Item.find(params[:id])
     erb :delete
   end
end

# delete '/food/:storage_type/:id' do
   # unless logged_in?
   #   redirect '/login'
   #   @message = "Login first to add some food"
   # else
      # @food_item = Food_Item.find(params[:id])
      # @food_item.destroy
   # end
# end

get '/guide' do
  erb :guide
end
