require 'github_api'
require 'pry'
require 'ghee'
require "octokit"
require 'date'

token = '37da512c008ce7b7b0da524b01d7f3f0ef68937a'

data = Octokit::Client.new(access_token: '37da512c008ce7b7b0da524b01d7f3f0ef68937a')   

user_data = data.user

user = Octokit.user 'philemonlloyds'

# puts user.name

# puts user.fields

# puts user[:company]

# puts user.rels[:gists].href

# octokit.client.users
# def user(user=nil, options = {})
#   get User.path(user), options
# end

# # octokit.client.repositories
# def repositories(user=nil, options = {})
#   paginate "#{User.path user}/repos", options
# end

  # def collaborators(repo, options = {})
  #       paginate "#{Repository.path repo}/collaborators", options
  #     end
name = 'someonetookit'
# GET /users/:username/repos
user_repos = Octokit.repositories name

# user_coll = Octokit.collaborators('someonetookit/Git_Achievement')  # need authentication
# puts user_repos[0][:stargazers_count]
# puts total_star_gazers
#stars--for--repos  

# GET /repos/:owner/:repo/contributors

# contributors = Octokit.

# GET /repos/:owner/:repo/stats/commit_activity - commit activity   


stargazers_count = 0
forks_count_count = 0
recent_repos =[]
user_languages_with_bytes = []
user_languages =[]

user_repos.each do |i|
  stargazers_count += i[:stargazers_count]
end

user_repos.each do |i|
  forks_count_count += i [:forks_count]
end

user_repos.each do |i|
  recent_repos << i[:name] if (i[:created_at].to_date > (Date.today - 5))
end

#languages 
# user_languages = Octokit.languages (name+"/"+user_repos[1].name)

user_repos.each do |i|
user_languages_with_bytes = Octokit.languages (name+"/"+ i.name)
user_languages << user_languages_with_bytes[0]
end

puts "Number of stars for #{name} = #{stargazers_count}"
puts "Number of forks for #{name} = #{forks_count_count}"


user_languages.each do |i|
  puts "Languages used by #{name} ==== #{i}"
end

recent_repos.each do |i|
  puts "Popular repos for #{name} #{i}"
end


