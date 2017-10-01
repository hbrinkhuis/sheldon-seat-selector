# frozen_string_literal: true

require 'rubygems'
require 'mechanize'
require 'json'
require 'logger'

host = 'https://www.pathe.nl'
show_id = '2308082'
ticket_start_path = "/tickets/start/#{show_id}"
ticket_transaction_path = '/api/transactions/'

a = Mechanize.new do |agent|
  agent.user_agent_alias = 'Mac Safari'
  logger = Logger.new STDOUT
  logger.level = Logger::DEBUG
  agent.log = logger

end

ticket_list_page = a.post("#{host}#{ticket_start_path}")

seat_page_link = ticket_list_page.links.select { |z| z.to_s == 'Stap 2: Stoel kiezen' }[0]
transaction_id = (%r{tickets\/([A-Z0-9]*)\/}.match seat_page_link.href)[1]

ticket_put_uri = "#{host}#{ticket_transaction_path}#{transaction_id}"
ticket_put_response = a.put(ticket_put_uri,
                            { 'tickets': [{ 'type': '382738', 'number': '6' }] }.to_json,
                            'Referer' => "#{host}/tickets/#{transaction_id}",
                            'Content-Type' => 'application/json; charset=UTF-8',
                            'Accept' => 'application/json, text/javascript')


seat_page = seat_page_link.click

free_seat_number = seat_page.parser.css("#seats li[class!='seat-sold']")
                       .css("li[class!=' seat-handicapped']")
                       .first[:id]

seat_put_uri = "#{host}/tickets/#{transaction_id}/seats/#{free_seat_number}"

seat_put_response = a.put(seat_put_uri, '')
pp seat_put_response
