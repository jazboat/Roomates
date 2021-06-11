

require 'sinatra' 
require 'sinatra/reloader' if development?
require 'bcrypt'
require 'pry' if development?

require_relative "db/helpers.rb"

enable :sessions 

def current_profile  

    run_sql("SELECT * FROM profiles WHERE user_id = #{session[:user_id]}")[0]

end

def 

def user

    run_sql("SELECT * FROM users WHERE id = #{session[:user_id]};")[0]

end

def current_user
    if session[:user_id] == nil
    return {}
    end

    run_sql("SELECT * FROM users WHERE id = #{session[:user_id]};")[0]
end

def logged_in?
    if session[:user_id] == nil
        return false
    else
        return true
    end
end

get '/' do
    profiles = run_sql("SELECT * FROM profiles;")
    erb :index, locals: { profiles: profiles }
end


get '/profiles/new' do
    erb(:create_profile)
end

get '/profiles/:id' do
    current_profile
    erb :user_profile, locals: { profile: current_profile }
end

get '/my_profile' do
    # binding.pry
    if session[:user_id] == nil
    
        redirect '/login'
        
    else
    erb :user_profile, locals: { profile: current_profile }
    end 
end

post '/profiles' do
    # redirect '/login' unless logged_in?
    #selecting the user profile with the login user_id 
    res = run_sql("SELECT * FROM profiles WHERE user_id = $1;", [session[:user_id]])
    # if there is a profile will be redirect
    if res.count == 1
        redirect '/profiles/:id/edit'
    else 
    sql = "INSERT INTO profiles (first_name, last_name, image_url, gender, employment, smoker, pets, children, drunk, peeve, tea_or_coffee, user_id) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12);"
    run_sql(sql, [
        params['first_name'],
        params['last_name'],
        params['image_url'],
        params['gender'],
        params['employment'],
        params['smoker'],
        params['pets'],
        params['children'],
        params['drunk'],
        params['peeve'],
        params['tea_or_coffee'],
        session[:user_id]
    ])
    redirect '/'
    end
end

delete '/profiles/:id' do

    redirect '/login' unless logged_in? 


    sql = "DELETE FROM profiles WHERE user_id = $1;"
    run_sql(sql, [session[:user_id]])
    
    redirect '/'
end

get '/profiles/:id/edit' do

    res = run_sql("SELECT * FROM profiles WHERE user_id = $1;", [session[:user_id]])
    profile = res[0]
    erb :edit_profile_form, locals: { profile: profile }
end

put '/profiles/:id' do
    
    sql = "UPDATE profiles SET first_name = $1, last_name = $2, image_url = $3, gender = $4, employment = $5, smoker = $6, pets = $7, children = $8, drunk = $9, peeve = $10, tea_or_coffee = $11  WHERE user_id = $12;"
    
    
    run_sql(sql, [
    params['first_name'],
    params['last_name'],
    params['image_url'],
    params['gender'],
    params['employment'],
    params['smoker'],
    params['pets'],
    params['children'],
    params['drunk'],
    params['peeve'],
    params['tea_or_coffee'],
    session[:user_id]
    ])

    
    redirect "/my_profile"
end

get '/login' do
    erb :login
end

get '/sign_up' do
    erb :sign_up
end

post '/users' do

    password_digest = BCrypt::Password.create(params['password'])
    
    sql = "INSERT INTO users (email, password_digest, first_name, last_name) VALUES ($1, $2, $3, $4);"
    run_sql(sql, [
        params['email'],
        password_digest,
        params['first_name'],
        params['last_name'],
    ])
    records = run_sql("SELECT * FROM users WHERE email = $1;", [params['email']])
    session[:user_id] == records[0]['id']
    redirect '/profiles/new'
end

post '/session' do
    # got email & password
    # lookup the record by the email address
    records = run_sql("SELECT * FROM users WHERE email = $1;", [params['email']])

    if records.count > 0 && BCrypt::Password.new(records[0]['password_digest']) == params['password']
    # yeah
    # write it down that you are now logged in
    # session is like a global hash 
    # one for every user
    # we will make up a key and assign a value to remeber this user is logged in
    # single source of truth - storing only the id - get the rest from db
        logged_in_user = records[0]
        session[:user_id] = logged_in_user["id"]
        redirect '/'
    else
        
        erb :login
    end

end

delete '/session' do
    session[:user_id] = nil
    redirect '/login'
end



# profile search that isnt their own
# profile = run_sql("SELECT * FROM profile WHERE user_id = #{params['id']};")[0]

