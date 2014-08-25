class CREST
  include HTTParty
  base_uri 'public-crest.eveonline.com'
  format :json

  def self.industry_indices
    Array(get("/industry/systems/").parsed_response['items'])
  end
end
