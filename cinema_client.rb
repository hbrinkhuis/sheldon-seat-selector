class CinemaClient
  def initialize(show_id)
    @show_id = show_id
    @host = 'https://www.pathe.nl'
    @transaction_start_path = "#{@host}/tickets/start/#{@show_id}"
    @transaction_api_path = '/api/transactions/'
    @agent = Mechanize.new do |agent|
      agent.user_agent_alias = 'Mac Safari'
      logger = Logger.new STDOUT
      logger.level = Logger::DEBUG
      agent.log = logger
    end
  end

  def start_ticket_transaction
    ticket_list_page = @agent.post(@transaction_start_path)
    @transaction_id = (%r{tickets\/(?<tid>[A-Z0-9]*)}.match ticket_list_page.uri.path)[:tid]
  end

  def reserve_tickets(number)
    ticket_put_uri = "#{@host}#{@transaction_api_path}#{@transaction_id}"
    headers = { 'Referer' => "#{@host}/tickets/#{@transaction_id}",
                'Content-Type' => 'application/json; charset=UTF-8',
                'Accept' => 'application/json, text/javascript' }
    entity = { 'tickets': [{ 'type': '382738', 'number': number.to_s }] }
    @agent.put(ticket_put_uri, entity.to_json, headers)
  end

  def get_seat_map
    ticket_list_page = @agent.history.find { |z| z.uri.path == "/tickets/#{@transaction_id}"}
    seat_page_link = ticket_list_page.links.find { |z| z.to_s == 'Stap 2: Stoel kiezen' }
    seat_page = seat_page_link.click

  end
end