class CREST
  include HTTParty
  base_uri 'public-crest.eveonline.com'
  format :json

  def self.industry_indices
    { rows: Array(get("/industry/systems/").parsed_response['items']), expires_at: (4.hours - 10.minutes).from_now }
  end
end
