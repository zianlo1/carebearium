if Rails.env.development?
  require_relative 'task_helpers'

  namespace :pirates do
    task :update do
      region_pirates = {}

      agent = Mechanize.new

      read_seed_file('solar_systems.json').each do |row|
        next if region_pirates[row[:regionID]].present?

        page = agent.get "http://evemaps.dotlan.net/system/#{row[:id]}"

        label = page.parser.xpath('//b[contains(text(), "Local Pirates")]').first

        pirate_name = label.parent.parent.children[7].text

        region_pirates[row[:regionID]] = pirate_name
      end

      pirate_names = region_pirates.values.uniq.sort.each_with_index.each_with_object({}) do |(name, index), map|
        map[index] = name
      end

      region_pirates.each do |region_id, pirate_name|
        region_pirates[region_id] = pirate_names.key pirate_name
      end

      write_static_data 'RegionPirates', region_pirates
      write_static_data 'PirateNames', pirate_names
    end
  end
end
