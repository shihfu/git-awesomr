# Homepage (Root path)
get '/' do
  erb :index
end

get '/user' do
  erb :'user/index'
end

get '/group' do
  erb :'group/index'
end