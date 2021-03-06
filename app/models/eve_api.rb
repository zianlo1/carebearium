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
    formatted_response "/Eve/ConquerableStationList.xml.aspx", throttle_update: 24.hours
  end

  def self.sovereignty
    formatted_response "/Map/Sovereignty.xml.aspx", throttle_update: 24.hours
  end

  def self.names(ids)
    formatted_response "/Eve/CharacterName.xml.aspx", query: { ids: Array(ids).join(',') }
  end

  private

  def self.formatted_response(endpoint, throttle_update: 0, query: {})
    response = get(endpoint, query: query).parsed_response['eveapi']

    utc = ActiveSupport::TimeZone.new('UTC')

    expires_at = utc.parse response['cachedUntil']

    rows = Array(response['result']['rowset']['row'])

    { rows: rows, expires_at: expires_at + throttle_update }
  end
end
