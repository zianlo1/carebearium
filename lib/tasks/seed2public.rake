if Rails.env.development?
  require 'multi_json'
  require 'oj'

  def read_file(filename)
    MultiJson.load File.read(Rails.root.join 'db', 'seeds', filename), symbolize_keys: true
  end

  def write_file(filename, data)
    File.open(Rails.root.join('public', 'api', filename), 'w') do |f|
      f.write(MultiJson.dump data)
    end
  end

  def write_static_data(header, data)
    File.open(Rails.root.join('app', 'assets', 'javascripts', 'data', "#{header.underscore}.coffee"), 'w') do |f|
      f.write("CB.StaticData.#{header} = #{MultiJson.dump data}")
    end
  end

  namespace :seed2public do
    task :solar_systems do
      data  = {}
      names = {}

      read_file('solar_systems.json').each do |row|
        system = row.slice(:regionID, :security, :beltCount)

        system[:stations] = []
        system[:agents] = []
        system[:jumps] = []

        data[row[:id]] = system
        names[row[:id]] = row[:name]
      end

      read_file('ice_belts.json').each do |row|
        next unless data[row[:id]]
        data[row[:id]][:ice] = true
      end

      read_file('stations.json').each do |row|
        next unless data[row[:solarSystemID]]
        data[row[:solarSystemID]][:stations] ||= []
        data[row[:solarSystemID]][:stations] << row.slice(:name, :refinery, :repair, :factory, :lab, :insurance)
      end

      levels = Set.new
      divisions = Set.new

      read_file('agents.json').each do |row|
        levels.add row[:level]
        divisions.add row[:division]
      end

      divisionMap = {}
      divisions.to_a.sort.each_with_index do |divisions, index|
        divisionMap[index] = divisions
      end

      read_file('agents.json').each do |row|
        next unless data[row[:solarSystemID]]
        data[row[:solarSystemID]][:agents] ||= []
        agent = row.slice(:corporationID, :level)
        agent[:division] = divisionMap.key(row[:division])
        data[row[:solarSystemID]][:agents] << agent
      end

      read_file('jumps.json').each do |row|
        next unless data[row[:from]]
        data[row[:from]][:jumps] = row[:to].split(',').map(&:to_i).sort
      end

      limits = {}

      securities = data.values.map{ |v| v[:security] }.compact
      limits[:security] = { min: securities.min, max: securities.max }

      belt_counts = data.values.map{ |v| v[:beltCount] }.compact
      limits[:belt_count] = { min: belt_counts.min, max: belt_counts.max }

      station_counts = data.values.map{ |v| v[:stations].size }.compact
      limits[:station_count] = { min: station_counts.min, max: station_counts.max }

      agent_counts = data.values.map{ |v| v[:agents].size }.compact
      limits[:agent_count] = { min: agent_counts.min, max: agent_counts.max }

      jump_counts = data.values.map{ |v| v[:jumps].size }.compact
      limits[:jump_count] = { min: jump_counts.min, max: jump_counts.max }

      write_file 'solar_systems_static.json', data
      write_file 'limits_static.json', limits

      write_static_data 'AgentLevels', levels.to_a.sort
      write_static_data 'AgentDivisions', divisionMap
      write_static_data 'SolarSystemNames', names
    end

    task :corporations do
      output = {}

      read_file('corporations.json').each do |row|
        output[row[:corporationID]] = row[:corporationName]
      end

      write_static_data 'Corporations', output
    end

    task :regions do
      output = {}

      read_file('regions.json').each do |row|
        output[row[:regionID]] = row[:regionName]
      end

      write_static_data 'Regions', output
    end
  end

  desc "Convert seed files to public"
  task seed2public: %w(solar_systems corporations regions).map{ |t| "seed2public:#{t}" }
end
