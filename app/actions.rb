# Homepage (Root path)

def current_user
  User.find(session[:user_id]) if session[:user_id]
end

# helpers do
#   def current_user
#     binding.pry
#     if session[:user_id]
#       if @current_user.nil?
#         @current_user = User.find(session[:user_id])
#       end
#       # Can be rewritten as
#       # @current_user ||= User.find(session[:user_id])
#     end
#     @current_user
#   end
# end


get "/" do
  erb :index
end

get "/me" do
  @user = current_user
  json @user
end

get '/login' do
  client_id = 'ec929278fb87047f1280'
  redirect "https://github.com/login/oauth/authorize?scope=user&client_id=#{client_id}"
end

get '/user/login' do
  @user = current_user
  erb :login
end


get '/callback' do
  # Get temporary GitHub code...
  session_code = request.env['rack.request.query_hash']['code']
 
  result = RestClient.post('https://github.com/login/oauth/access_token',
    {
      client_id: ENV['CLIENT_ID'] || 'ec929278fb87047f1280',
      client_secret: ENV['CLIENT_SECRET'] || '2f6d93489179df343c2fc243d0a1aafd471d556e',
      code: session_code,
    },
    accept: :json
  ) 
  # Make the access token available across sessions.
  token = JSON.parse(result)['access_token']

  data = Octokit::Client.new(access_token: token).user

  user = User.find_by(username: data.login)

  unless user then
    user = User.create(
      username: data.login,
      token: token,
      avatar_url: data.avatar_url,
      location: data.location,
      followers: data.followers,
      following: data.following,
      public_repos: data.public_repos,
      public_gists: data.public_gists,
      start_date: data.created_at
    )
  end

  session[:user_id] = user.id

  
  redirect '/user/login'

end

get '/logout' do
  session.clear
  redirect '/'
end


get '/user' do
  erb :'user/index'
end

get '/id' do
  @user = current_user
  erb :'/users/id'
end

get '/group' do
  erb :'group/index'
end