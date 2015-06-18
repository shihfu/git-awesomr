require "sinatra"
require "sinatra/activerecord"
require 'rest-client'
require 'json'
require 'octokit'
require 'pp' # for pretty print debugging

# Needed for preserving github auth tokens across sessions.
enable :sessions

CLIENT_ID = ENV['GH_BASIC_CLIENT_ID']
CLIENT_SECRET = ENV['GH_BASIC_SECRET_ID']

def authenticated?
  session[:access_token]
end
 
def authenticate!
  erb :"login", :locals => {:client_id => CLIENT_ID}
end

def get_github_data()
  if !authenticated?
    authenticate!
  else
    client = Octokit::Client.new :access_token => session[:access_token]
    
    # Create a hash for collecting our example data.
    data = Hash.new
    
    # Get various types of data using Octokit.rb
    
    # User Data: 
    # User data is available via client.user. As long as you have be granted access
    # to the "user" scope, you can access any values given in this example API
    # response: http://developer.github.com/v3/users/#response
    data[:login] = client.user.login # => "octocat"
    data[:email] = client.user.email # => "octocat@github.com"
    data[:location] = client.user.location # => "San Francisco"
    
    # Repository Data:
    # Repository data is available via client.repository (for a specific repo)
    # or client.repositories for the full list of repos. As long as you have been
    # granted access to the "repo" scope, you can access any values given in this
    # example API response: http://developer.github.com/v3/repos/#response-1
    #
    # Get data from a specific repository, if that repository exists.
    if client.repository?("octocat/Hello-World")
      data[:repo_id] = client.repository("octocat/Hello-World").id
      data[:repo_forks] = client.repository("octocat/Hello-World").forks_count
      data[:repo_stars] = client.repository("octocat/Hello-World").stargazers_count
      data[:repo_watchers] = client.repository("octocat/Hello-World").watchers_count
      data[:repo_full_name] = client.repository("octocat/Hello-World").full_name
      data[:repo_description] = client.repository("octocat/Hello-World").description
      # Note: You can see all repo methods by printing client.repository("octocat/Hello-World").methods
    end
    
    # Instantiate an array for storing repo names.
    data[:repo_names] = Array.new
    # Loop through all repositories and collect repo names.
    client.repositories.each do |repo|
      data[:repo_name] << repo.name
    end
    
    return data
  end
end
