# Homepage (Root path)

def current_user
  User.find(session[:user_id]) if session[:user_id]
end

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
  # erb :login
  erb :'user/index'
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

  user_repos = Octokit.repositories data.login

  user = User.find_by(username: data.login)

  user_full_name = data.name.split
  total_commits = 0
  unless user then
    user = User.create(
      username: data.login,
      first_name: user_full_name[0],
      last_name: user_full_name[1],
      token: token,
      avatar_url: data.avatar_url,
      location: data.location,
      followers: data.followers,
      public_repos: data.public_repos,
      public_gists: data.public_gists,
      start_date: data.created_at
    )

    user_repos.each do |repo|
      commit_activity = Octokit.participation_stats(data.login+"/"+repo.name)
      total_commits += commit_activity[:owner].inject(0){|total,week| total+week}
      user_achievement_info = Repo.create(
      name: repo.name,
      stars_count: repo.stargazers_count,
      forks_count: repo.forks_count,
      commits_count: total_commits,
      language: repo.language
      )
      total_commits = 0
    end
  end


  # stargazers_count = 0
  # forks_count_count = 0
  # total_commits = 0
  # recent_repos = []
  # user_languages = []
  # user_unique_languages = []

  # user_repos.each do |i|
  #   commit_activity = Octokit.participation_stats(data.login+"/"+user_repos[1].name)
  #   total_commits += commit_activity[:owner].inject(0){|total,week| total+week}
  # end

  # user_repos.each do |i|
  #   stargazers_count += i[:stargazers_count]
  # end

  # user_repos.each do |i|
  #   forks_count_count += i [:forks_count]
  # end

  # user_repos.each do |i|
  #   recent_repos << i[:name] if (i[:updated_at].to_date > (Date.today - 50))
  # end

  # user_repos.each do |i|
  # user_languages << i [:language] if i [:language]
  # end

  # user_unique_languages = user_languages.uniq

  # user_achievement_info = Repo.create(
  #   name: data.login,
  #   stars_count: stargazers_count,
  #   forks_count: forks_count_count,
  #   commits_count: total_commits,
  #   language: user_unique_languages
  #   )

  # end

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

# get '/group' do
#   erb :'group/new'
# end

# post '/group' do
#   name = params[:name]
#   username = params[:username]

#   group = Group.find_by(name: name)
#     if group
#       redirect '/group/:id'
#     else
#       group = Group.create(name: name)
#       redirect '/group/:id'
#     end
# end

get '/group' do
  # GRAPH DATA
  @achievement = {}
  @achievement[:user] = [1, 2, 3, 2, 2, 2, 3]
  @achievement[:group] = [2, 1, 2, 3, 2, 3, 1]

  erb :'group/index'
end

