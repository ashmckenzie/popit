class App < Sinatra::Base

  get '/' do
  end

  post '/key/new' do
    UUID.generate
  end
end
