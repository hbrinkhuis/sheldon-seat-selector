require 'rubygems'
require 'sinatra'
require './cinema_client.rb'

host = 'https://www.pathe.nl'

set :bind, '0.0.0.0'
set :port, 4567

get '/start_transaction/:show_id' do
  agent = CinemaClient.new(host)
  transaction_id = agent.start_ticket_transaction( params['show_id'])
  puts "Transaction ID: #{transaction_id}"
  agent.shutdown
  JSON({ transaction_id: transaction_id })
end

get '/stop_transaction/:transaction_id' do
  agent = CinemaClient.new(host)
  agent.stop_ticket_transaction(params['transaction_id'])
  agent.shutdown
  JSON({result: 'ok'})
end

get '/seat_map/:transaction_id' do
  agent = CinemaClient.new(host)
  map = agent.get_seat_map(params['transaction_id'])
  agent.shutdown
  JSON(map)
end

post '/reserve_seats/:transaction_id/' do
  agent = CinemaClient.new(host)

  #reservation = agent.reserve_tickets()
end