#!/usr/bin/env ruby

require 'sinatra'
require 'octokit'

CLIENT_ID = 'ec929278fb87047f1280'
CLIENT_SECRET = '2f6d93489179df343c2fc243d0a1aafd471d556e'

use Rack::Session::Cookie, :secret => rand.to_s()

def current_user
  User.find(session[:user_id]) if session[:user_id]
end

def achievements
  Achievement.all
end

get "/" do
  erb :index
end

def authenticated?
  session[:access_token]
end

def authenticate!
  client = Octokit::Client.new
  url = client.authorize_url CLIENT_ID, :scope => 'user'

  redirect url
end


def account_open
  @days_open = (Date.today - @user.start_date).to_i 
  @years_open = @days_open/365.to_f 
  achievement_name = @achievement.where(name: "Account Open") 
  achievements = achievement_name.select {|a| a.criteria <= @years_open} 
  @progress_bar_acc_open = @days_open/1095.to_f*100
  # @progress_bar_acc_open = [@progress_bar_acc_open,@max_progress_bar].min

  if achievements[0] 
    @open_ach_url_1 = achievements[0][:url]
    @total_flags +=1
  end

  if achievements[1] 
    @open_ach_url_2 = achievements[1][:url]
    @total_flags +=1
  end

  if achievements[2] 
    @open_ach_url_3 = achievements[2][:url]
    @total_flags +=1
  end

end

def language_achieved
  @lang_all=[]
  @user.repos.each do |repo| 
    @lang_all << repo.language 
    @lang_all.compact!
  end 

  @lang_all.uniq!
  achievement_name =[]
  achievement_name = @achievement.where name: "Language"
  achievements = achievement_name.select{|level| level.criteria <=(@lang_all.count) } 
  @progress_bar_lang = @lang_all.count/achievement_name[2][:criteria].to_f*100

 if achievements[0] 
    @lang_ach_url_1 = achievements[0][:url]if achievements[0]
    @total_flags +=1
  end

  if achievements[1] 
    @lang_ach_url_2 = achievements[1][:url] if achievements[1]
    @total_flags +=1
  end
  
  if achievements[2] 
    @lang_ach_url_3 = achievements[2][:url] if achievements[2]
    @total_flags +=1
  end

end

def followers_achieved
  followers = @user.followers
  achievement_name = @achievement.where name: "Followers"
  achievements = []
  achievements = achievement_name.select {|a| a.criteria <= followers}

  if achievements[0] 
    @follow_ach_url_1 = achievements[0][:url] if achievements[0]
    @total_flags +=1 
  end

  if achievements[1] 
    @follow_ach_url_2 = achievements[1][:url] if achievements[1]
    @total_flags +=1
  end

  if achievements[2] 
    @follow_ach_url_3 = achievements[2][:url] if achievements[2]
    @total_flags +=1
  end

  followers_criteria = 0
  followers_criteria = achievement_name[2][:criteria]
  @progress_bar_followers = followers/followers_criteria.to_f*100 
end

def repositories_achieved
  respositories = @user.public_repos
  achievement_name = @achievement.where name: "Repos"
  achievements = []
  achievements = achievement_name.select {|a| a.criteria <= respositories}

  if achievements[0] 
    @repos_ach_url_1 = achievements[0][:url] if achievements[0]
     @total_flags +=1 
  end

  if achievements[1] 
    @repos_ach_url_2 = achievements[1][:url] if achievements[1]
     @total_flags +=1 
  end

  if achievements[2] 
    @repos_ach_url_3 = achievements[2][:url] if achievements[2]
     @total_flags +=1 
  end

  repos_criteria = 0
  repos_criteria = achievement_name[2][:criteria]
  @progress_bar_repos = respositories/repos_criteria.to_f*100 
end


def forks_achieved
 @forks_all = 0
 @user.repos.each do |repo| 
 @forks_all += repo.forks_count 
 end 

achievement_name = @achievement.where name: "Forks"
achievements = []
achievements = achievement_name.select {|a| a.criteria <= @forks_all}

if achievements[0] 
  @forks_ach_url_1 = achievements[0][:url] if achievements[0]
  @total_flags +=1 
end

if achievements[1] 
  @forks_ach_url_2 = achievements[1][:url] if achievements[1]
   @total_flags +=1 
end

if achievements[2] 
  @forks_ach_url_3 = achievements[2][:url] if achievements[2]
  @total_flags +=1 
end

forks_criteria = 0
forks_criteria = achievement_name[2][:criteria]

@progress_bar_forks =@forks_all/forks_criteria.to_f*100 
end


def commits_achieved
  days_open = (Date.today - @user.start_date).to_i 
  @commits_all = 0
  @user.repos.each do |repo| 
  @commits_all += repo.commits_count 
  end 

  achievement_name = @achievement.where name: "Commits"
  achievements = []
  achievements = achievement_name.select {|a| a.criteria <= @commits_all}

  if achievements[0]
   @commits_ach_url_1 = achievements[0][:url] if achievements[0]
   @total_flags +=1 
  end

  if achievements[1]
    @commits_ach_url_2 = achievements[1][:url] if achievements[1]
    @total_flags +=1 
  end

  if achievements[2]
    @commits_ach_url_3 = achievements[2][:url] if achievements[2]
    @total_flags +=1 
  end

  commits_criteria = 0
  commits_criteria = achievement_name[2][:criteria]

  @progress_bar_commits = @commits_all/commits_criteria.to_f*100 
end

def stars_achieved
  @stars_all = 0
  @user.repos.each do |repo| 
  @stars_all += repo.stars_count 
  end 

  achievement_name = @achievement.where name: "Stars"
  achievements = []
  achievements = achievement_name.select {|a| a.criteria <= @stars_all}

  if achievements[0]
    @stars_ach_url_1 = achievements[0][:url] if achievements[0]
    @total_flags +=1 
  end

  if achievements[1]
    @stars_ach_url_2 = achievements[1][:url] if achievements[1]
    @total_flags +=1 
  end

  if achievements[2]
    @stars_ach_url_3 = achievements[2][:url] if achievements[2]
    @total_flags +=1 
  end

  stars_criteria = 0
  stars_criteria = achievement_name[2][:criteria]

  @progress_bar_stars = @stars_all/stars_criteria.to_f*100 
end

post '/search' do
  searchname = params[:searchname]
  @max_progress_bar = 100
  # @user = User.find_by(username: searchname)
  client = Octokit::Client.new(:login => 'philemonlloyds', :password => 'Binitha@1088')
  @search_user = Octokit.user searchname
  user_full_name = @search_user[:name].split

  search_user = User.create(
      username: searchname,
      first_name: user_full_name[0],
      last_name: user_full_name[1],
      avatar_url: @search_user[:avatar_url],
      location: @search_user[:location],
      followers: @search_user[:followers],
      public_repos: @search_user[:public_repos],
      public_gists: @search_user[:public_gists],
      start_date: @search_user[:created_at]
    ) 

  @user_repos = @search_user.rels[:repos].get.data

  @user_repos.each do |repo|
      user_achievement_info = Repo.create(
      name: repo.name,
      user_id: search_user.id,
      stars_count: repo.stargazers_count,
      forks_count: repo.forks_count,
      # commits_count: total_commits,
      language: repo.language
      )
      total_commits = 0
    end

  session[:user_id] = search_user.id
  @total_flags = 0 
  @user = search_user
  @achievement = achievements
  account_open
  language_achieved
  followers_achieved
  repositories_achieved
  forks_achieved
  stars_achieved
  @user.update(score: @total_flags/21.to_f*100.to_i)
  erb :'user/index'
end

get '/user/:username' do
  @total_flags = 0 
  @user = current_user
  @achievement = achievements
  client = Octokit::Client.new :access_token => session[:access_token]
  data = client.user
  user = User.find_by(username: data.login)
  @user_repos = Octokit.repositories data.login
  account_open
  language_achieved
  followers_achieved
  repositories_achieved
  forks_achieved
  commits_achieved
  stars_achieved
  user.update(score: @total_flags/21.to_f*100.to_i)
  erb :'user/index'
end

get '/login' do
  if !authenticated?
    authenticate!
  else
    access_token = session[:access_token]
    scopes = []

    client = Octokit::Client.new \
      :client_id => CLIENT_ID,
      :client_secret => CLIENT_SECRET

    begin
      client.check_application_authorization access_token
    rescue => e
      # request didn't succeed because the token was revoked so we
      # invalidate the token stored in the session and render the
      # index page so that the user can start the OAuth flow again
      session[:access_token] = nil
      return authenticate!
    end

    client = Octokit::Client.new :access_token => access_token
    data = client.user
    user = User.find_by(username: data.login)
    session[:user_id] = user.id
    redirect "/user/#{user.username}"
end
end

get '/callback' do
  session_code = request.env['rack.request.query_hash']['code']
  result = Octokit.exchange_code_for_token(session_code, CLIENT_ID, CLIENT_SECRET)
  session[:access_token] = result[:access_token]

  client = Octokit::Client.new :access_token => session[:access_token]
  data = client.user
  user = User.find_by(username: data.login)
  user_repos = Octokit.repositories data.login
  user_full_name = data.name.split
  total_commits = 0

  unless user then
    user = User.create(
      username: data.login,
      first_name: user_full_name[0],
      last_name: user_full_name[1],
      token: session[:access_token],
      avatar_url: data.avatar_url,
      location: data.location,
      followers: data.followers,
      public_repos: data.public_repos,
      public_gists: data.public_gists,
      start_date: data.created_at
    )

    user_repos.each do |repo|
      commit_activity = Octokit.participation_stats(data.login+"/"+repo.name)
      total_commits += commit_activity[:owner].inject(0){|total,week| total+week} if commit_activity

      user_achievement_info = Repo.create(
      name: repo.name,
      user_id: user.id,
      stars_count: repo.stargazers_count,
      forks_count: repo.forks_count,
      commits_count: total_commits,
      language: repo.language
      )
      total_commits = 0
    end
 end

  session[:user_id] = user.id

  redirect "/user/#{user.username}"
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
  @achievement[:user] = [@user.acct_age_level, @user.languages_level, @user.followers_level, @user.repos_level, @user.forks_level, @user.commits_level, @user.stars_level]
  @achievement[:group] = [2, 1, 2, 3, 2, 3, 1]


  @average_score = {}
  @average_score[:user] = [10, 20, 30, 20, 20, 20, 30, 30]
  @average_score[:group] = [20, 20, 20, 20, 20, 20, 20, 20]
  erb :'group/index'
end
