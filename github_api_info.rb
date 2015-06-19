require 'github_api'
require 'pry'
require 'ghee'
require "octokit"
require 'date'

name = 'donburks'
# GET /users/:username/repos
# user_repos = Octokit.repositories name

commit_activity = Octokit.commit_activity_stats()

# GET /repos/:owner/:repo/contributors



# stargazers_count = 0
# forks_count_count = 0
# recent_repos =[]
# user_languages =[]
# user_unique_languages =[]

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
#   user_languages << i [:language] if i [:language]
# end


# puts "Number of stars for #{name} = #{stargazers_count}"
# puts "Number of forks for #{name} = #{forks_count_count}"

# puts "Number of langauages for user #{user_languages.uniq.count}"

# user_unique_languages = user_languages.uniq

# user_unique_languages .each do |i|
#   puts "Languages used by #{name} ==== #{i}"
# end


# recent_repos.each do |i|
#   puts "Popular repos for #{name} #{i}"
# end


