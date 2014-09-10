class EveApi
  include HTTParty
  base_uri 'api.eveonline.com'
  format :xml

  def self.kills
    Array(get("/map/Kills.xml.aspx").parsed_response['eveapi']['result']['rowset']['row'])
  end
end
