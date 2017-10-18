require 'rubygems'
require 'sinatra'
require './cinema_client.rb'

host = 'https://www.pathe.nl'

get '/start_transaction/:show_id' do
  agent = CinemaClient.new('https://www.pathe.nl')
  transaction_id = agent.start_ticket_transaction( params['show_id'])
  puts "Transaction ID: #{transaction_id}"
  agent.shutdown
  JSON({ transaction_id: transaction_id })
end

get '/seat_map/:transaction_id' do
  agent = CinemaClient.new(host)
  map = agent.get_seat_map(params['transaction_id'])
  agent.shutdown
  JSON(map)
end

get '/stop_transaction/:transaction_id' do
  agent = CinemaClient.new(host)
  agent.stop_ticket_transaction(params['transaction_id'])
  agent.shutdown
  JSON({result: 'ok'})
end

get '/reserve_seats/:transaction_id/:seat_id/:number_of_seats' do
  
end