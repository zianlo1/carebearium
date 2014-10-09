class EveApi
  include HTTParty
  base_uri 'api.eveonline.com'
  format :xml

  def self.kills
    formatted_response("/map/Kills.xml.aspx")
  end

  def self.jumps
    formatted_response("/map/Jumps.xml.aspx")
  end

  def self.conquerable_stations
    formatted_response("/Eve/ConquerableStationList.xml.aspx")
  end

  private

  def self.formatted_response(endpoint)
    response = get(endpoint).parsed_response['eveapi']

    utc = ActiveSupport::TimeZone.new('UTC')

    expires_at = utc.parse response['cachedUntil']

    rows = Array(response['result']['rowset']['row'])

    { rows: rows, expires_at: expires_at }
  end
end
