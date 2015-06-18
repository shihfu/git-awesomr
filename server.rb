require 'octokit'

client = Octokit::Client.new(:access_token => "3e8a7d7a66e54f67430b94826737de95c650b1d5")

user = client.user
puts user.login

