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

get '/user/:username' do
  @user = current_user
  @achievement = achievements
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
