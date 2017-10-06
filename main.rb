require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'pry'

require_relative 'db_config'
require_relative 'models/food_item'
require_relative 'models/guide'
require_relative 'models/storage_type'
require_relative 'models/user'

# Sessions to remember current_user
enable :sessions

#===========================================================
# Helpers
#===========================================================
helpers do
  def current_user
    User.find_by(id: session[:user_id])
  end

  def logged_in?
    !!current_user
  end

  def not_logged_in_redirect
    if !logged_in?
      redirect '/404'
    end
  end

  def items_count
    get_storage_type_id = StorageType.find_by(storage_name: params[:storage_type]).id
    @all_food = FoodItem.all.where(storage_type_id: get_storage_type_id, user_id: current_user.id)
  end

  def user_items_count
    @user_food = current_user.food_items
  end

  def new_time
    @new_time = Time.new
  end

  def single_food_item
    @food_item = FoodItem.find(params[:id])
  end

  def days_remaining_single
    @days_left = (single_food_item.expiry_date - new_time.strftime('%Y-%m-%d').to_date).to_i
  end
end

#===========================================================
# Users
#===========================================================
# Login
get '/login' do
  erb :login
end

post '/session' do
  user = User.find_by(email: params[:email])
  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect '/my_account'
  else
    @message = 'Incorrect email or password'
    erb :login
  end
end

# Logout
delete '/session' do
  session[:user_id] = nil
  redirect '/login'
end

# Create User
post '/create_user' do
  create_user = User.new
  create_user.name = params[:name]
  create_user.email = params[:email]
  create_user.password = params[:password]
  create_user.save

  if create_user.errors.messages.empty?
    @message = "Thank you #{params[:name]}, you can log in with your email #{params[:email]} and password"
    erb :login
  else
    @email_error = create_user.errors.messages[:email][0]
    erb :login
  end
end

# User when logged in
get '/my_account' do
  not_logged_in_redirect
  user_items_count
  erb :my_account
end

#===========================================================
# Functionality
#===========================================================
# Create
get '/food/:storage_type/new' do
  not_logged_in_redirect
  erb :new
end

#======================================================= Refactor this?
post '/food/:storage_type' do
  food = FoodItem.new
  food.item_name = params[:item_name]
  food.purchase_date = params[:purchase_date]
  food.expiry_date = params[:expiry_date]
  food.status = 'active'
  food.notification = params[:notification]
  if (params[:expiry_date].to_date - params[:notification].to_date).to_i <= 0
    @notification_error = 'You set the notification date past the expiry date, please enter an earlier date'
    redirect "/food/#{params[:storage_type]}/new"
  elsif (params[:notification].to_date - params[:purchase_date].to_date).to_i <= 0
    @notification_error = 'You set the notification date before the purchase date, please enter an later date'
    redirect "/food/#{params[:storage_type]}/new"
  end
  food.user_id = current_user.id
  get_storage_type = StorageType.find_by(storage_name: params[:storage_type])
  food.storage_type_id = get_storage_type.id
  food.save
  redirect "/food/#{params[:storage_type]}"
end

# Read
get '/' do
  erb :index
end

get '/404' do
  erb :error_page
end

get '/about' do
  erb :about
end

get '/food' do
  not_logged_in_redirect
  erb :food
end

get '/guide' do
  erb :guide
end

# Storage Type view
get '/food/:storage_type' do
  new_time
  not_logged_in_redirect
  items_count
  erb :storage
end

# Single Item view
get '/food/:storage_type/:id' do
  days_remaining_single
  not_logged_in_redirect
  erb :single
end

# Update
get '/food/:storage_type/:id/edit' do
  days_remaining_single
  not_logged_in_redirect
  erb :edit
end

#======================================================= Refactor this?
put '/food/:storage_type/:id' do
  days_remaining_single
  @food_item.item_name = params[:item_name]
  @food_item.purchase_date = params[:purchase_date]
  @food_item.expiry_date = params[:expiry_date]
  if params[:finished_food]
    @food_item.status = 'consumed'
  else
    @food_item.status = 'active'
  end
  @food_item.notification = params[:notification]
  if (params[:expiry_date].to_date - params[:notification].to_date).to_i <= 0
    @notification_error = 'You set the notification date past the expiry date, please enter an earlier date'
    redirect "/food/#{params[:storage_type]}/#{params[:id]}/edit"
  elsif (params[:notification].to_date - params[:purchase_date].to_date).to_i <= 0
    @notification_error = 'You set the notification date before the purchase date, please enter an later date'
    redirect "/food/#{params[:storage_type]}/#{params[:id]}/edit"
  end
  @food_item.user_id = current_user.id
  get_storage_type = StorageType.find_by(storage_name: params[:storage_type])
  @food_item.storage_type_id = get_storage_type.id
  if params[:days_left].to_i <= 0
    @food_item.status = 'expired'
  end
  @food_item.save
  redirect "/food/#{params[:storage_type]}/#{params[:id]}"
end

# Delete
get '/food/:storage_type/:id/delete' do
  not_logged_in_redirect
  @food_item = FoodItem.find(params[:id])
  erb :delete
end

delete '/food/:storage_type/:id' do
  not_logged_in_redirect
  @food_item = FoodItem.find(params[:id])
  @food_item.destroy
  redirect "/food/#{params[:storage_type]}"
end
