require 'rubygems'
require 'sinatra'
require './cinema_client.rb'


post '/seat-map/' do
  request.body.rewind  # in case someone already read it
  data = JSON.parse request.body.read
  "Hello #{data['name']}!"
end