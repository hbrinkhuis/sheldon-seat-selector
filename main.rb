# frozen_string_literal: true

require 'rubygems'
require 'mechanize'
require 'json'
require 'logger'
require './cinema_client.rb'

host = 'https://www.pathe.nl'
show_id = '2308082'
seat_id = '766089'

client = CinemaClient.new(show_id)

client.start_ticket_transaction

client.reserve_tickets(1)

map = client.get_seat_map


# transaction_start_path = "/tickets/start/#{show_id}"
# transaction_api_path = '/api/transactions/'
#
# a = Mechanize.new do |agent|
#   agent.user_agent_alias = 'Mac Safari'
#   logger = Logger.new STDOUT
#   logger.level = Logger::DEBUG
#   agent.log = logger
# end
#
# ticket_list_page = a.post("#{host}#{transaction_start_path}")
#
# seat_page_link = ticket_list_page.links.select { |z| z.to_s == 'Stap 2: Stoel kiezen' }[0]
# transaction_id = (%r{tickets\/([A-Z0-9]*)\/}.match seat_page_link.href)[1]
#
# ticket_put_uri = "#{host}#{transaction_api_path}#{transaction_id}"
# ticket_put_response = a.put(ticket_put_uri,
#                             { 'tickets': [{ 'type': '382738', 'number': '6' }] }.to_json,
#                             'Referer' => "#{host}/tickets/#{transaction_id}",
#                             'Content-Type' => 'application/json; charset=UTF-8',
#                             'Accept' => 'application/json, text/javascript')
#
#
# seat_page = seat_page_link.click
#
# seat_element = seat_page.parser.css("#seats li[id='#{seat_id}']")
#
# seats = seat_page.parser.css('#seats li')
# current_seat_row = (%r{top: (\d+)px}.match seat_element[0][:style])[1].to_i
# seat_rows = (seats.collect { |z| (%r{top: (\d+)px}.match z[:style])[1].to_i}).uniq.sort
# seat_previous_row = seat_rows[seat_rows.index(current_seat_row)-1]
# seat_next_row = seat_rows[seat_rows.index(current_seat_row)+1]
#
# front_seat = (seats.select { |z| z[:style].include? "top: #{seat_previous_row}" })[0][:id]
#
# seat_put_uri = "#{host}/tickets/#{transaction_id}/seats/#{front_seat}"
#
# seat_put_response = a.put(seat_put_uri, '')
# # pp seat_put_response
