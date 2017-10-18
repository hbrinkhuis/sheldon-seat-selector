# frozen_string_literal: true

require 'rubygems'
require 'mechanize'
require 'json'
require 'logger'
require './cinema_client.rb'

host = 'https://www.pathe.nl'
show_id = '2330593'
ticket_type = 393290
# seat_ids_to_exclude = [338988,338989]

client = CinemaClient.new(host, show_id)

transaction = client.start_ticket_transaction

client.reserve_tickets(transaction,12, ticket_type)

map = client.get_seat_map(transaction)

seats = map.select do |z|
  !z[:sold] &&
    !z[:handicapped] &&
    !z[:loveseat]
end

start_of_show = DateTime.new(2017,10,5,21,50,0,'+02:00')

client.shutdown

AGENT_ALIASES = [
    'Linux Firefox' ,
    'Linux Konqueror' ,
    'Linux Mozilla' ,
    'Mac Firefox' ,
    'Mac Mozilla' ,
    'Mac Safari 4' ,
    'Mac Safari' ,
    'Windows Chrome' ,
    'Windows IE 6' ,
    'Windows IE 7' ,
    'Windows IE 8' ,
    'Windows IE 9' ,
    'Windows IE 10' ,
    'Windows IE 11' ,
    'Windows Edge' ,
    'Windows Mozilla' ,
    'Windows Firefox' ,
    'iPhone' ,
    'iPad' ,
    'Android' ,
]

# seats.each_with_index do |seat,i|
#   c2 = CinemaClient.new(show_id, AGENT_ALIASES[(i % AGENT_ALIASES.length)])
#
#   c2.start_ticket_transaction
#   sleep(1)
#   c2.reserve_tickets(1)
#   sleep(2)
#   result = c2.reserve_seat(seat[:id])
#
#   c2.shutdown
#   sleep(3)
# end
