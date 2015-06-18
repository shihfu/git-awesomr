
# Homepage (Root path)

# get '/' do
#   erb :index#, :locals => {:client_id => "ec929278fb87047f1280"}
# end


# def helpers

  # def new_user
  #   client = Octokit::Client.new(:access_token => session[:access_token])


  #   user = client.user
    
  #   @user = User.create
  #   (
  #     username: user.login,
  #     token: session[:access_token],
  #     avatar_url: user.avatar_url,
  #     location: user.location,
  #     followers: user.followers,
  #     following: user.following,
  #     public_repos: user.public_repos,
  #     public_gists: user.public_gists,
  #     start_date: user.created_at
  #   )

  # end

# end

def current_user
  User.find(session[:user_id]) if session[:user_id]
end


get "/" do
  # gh_data = get_github_data()
  # Pass in the CLIENT_ID for the login button on the home page.
  # @user = current_user
  
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

  user = User.find_by(username: data.username)

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
  erb :login
end

get '/logout' do
  session.clear
  redirect '/'
end



# 3e8a7d7a66e54f67430b94826737de95c650b1d5