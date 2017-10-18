# frozen_string_literal: true
require 'mechanize'

class CinemaClient
  def initialize(host)
    @host = host
    @transaction_api_path = '/api/transactions/'
    @agent = Mechanize.new do |agent|
      agent.user_agent_alias = 'Mac Safari'
      logger = Logger.new STDOUT
      logger.level = Logger::DEBUG
      agent.log = logger
    end
  end

  def start_ticket_transaction(show_id)
    ticket_list_page = @agent.post("#{@host}/tickets/start/#{show_id}")
    (%r{tickets\/(?<tid>[A-Z0-9]*)}.match ticket_list_page.uri.path)[:tid]
  end

  def reserve_tickets(transaction_id, number, ticket_type)
    ticket_put_uri = "#{@host}#{@transaction_api_path}#{transaction_id}"
    headers = { 'Referer' => "#{@host}/tickets/#{transaction_id}",
                'Content-Type' => 'application/json; charset=UTF-8',
                'Accept' => 'application/json, text/javascript' }
    entity = { 'tickets': [{ 'type': ticket_type, 'number': number.to_s }] }
    begin
      result = @agent.put(ticket_put_uri, entity.to_json, headers)
    rescue Mechanize::ResponseCodeError
      pp result
    end
  end

  def reserve_seats(transaction_id, seat_id)
    seat_put_uri = "#{@host}/tickets/#{transaction_id}/seats/#{seat_id}"
    @agent.put(seat_put_uri, '')
  end

  def get_seat_map(transaction_id)
    seat_page = @agent.get("#{@host}/tickets/#{transaction_id}/stoelen")

    seat_page.parser.css('#seats li').collect do |z|
      matches = /left: (?<left>\d+)px; top: (?<top>\d+)px/.match z[:style]
      {
        top: matches[:top].to_i,
        left: matches[:left].to_i,
        id: z[:id],
        sold: !z[:class].nil? && (z[:class].include? 'seat-sold'),
        handicapped: !z[:class].nil? && (z[:class].include? 'seat-handicapped'),
        loveseat: !z[:class].nil? && (z[:class].include? 'seat-ls')
      }
    end
  end

  def stop_ticket_transaction(transaction_id)
    @agent.post("#{@host}/tickets-annuleren/#{transaction_id}")
  end

  def shutdown
    @agent.shutdown
  end
end
