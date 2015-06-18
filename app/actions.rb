
# Homepage (Root path)


get '/' do
  erb :index#, :locals => {:client_id => "ec929278fb87047f1280"}
end

get '/login' do
  client_id = 'ec929278fb87047f1280'
  redirect "https://github.com/login/oauth/authorize?scope=user:email,repo&client_id=#{client_id}"
end

get '/callback' do
  # get temporary GitHub code...
  session_code = request.env['rack.request.query_hash']['code']

  # ... and POST it back to GitHub
  result = RestClient.post('https://github.com/login/oauth/access_token',
                          {
                            client_id: ENV['CLIENT_ID'] || 'ec929278fb87047f1280',
                            client_secret: ENV['CLIENT_SECRET'] || '2f6d93489179df343c2fc243d0a1aafd471d556e',
                            code: session_code,
                          },
                          accept: :json
                          )

  # extract the token and granted scopes
  session[:access_token] = JSON.parse(result)['access_token']
  redirect '/'
end

get '/userlogin' do
client = Octokit::Client.new(:access_token => session[:access_token])
user = client.user
user.login
end



# 3e8a7d7a66e54f67430b94826737de95c650b1d5