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

  namespace :seed2public do
    task :solar_systems do
      data = {}

      read_file('solar_systems.json').each do |row|
        data[row[:id]] = row.slice(:name, :regionID, :security, :beltCount)
      end

      read_file('ice_belts.json').each do |row|
        next unless data[row[:id]]
        data[row[:id]][:ice] = true
      end

      read_file('stations.json').each do |row|
        next unless data[row[:solarSystemID]]
        data[row[:solarSystemID]][:stations] ||= []
        data[row[:solarSystemID]][:stations] << [
          row[:name],
          row[:refinery],
          row[:repair],
          row[:factory],
          row[:lab],
          row[:insurance]
        ]
      end

      read_file('agents.json').each do |row|
        next unless data[row[:solarSystemID]]
        data[row[:solarSystemID]][:agents] ||= []
        data[row[:solarSystemID]][:agents] << [
          row[:corporationID],
          row[:kind],
          row[:level]
        ]
      end

      read_file('jumps.json').each do |row|
        next unless data[row[:from]]
        data[row[:from]][:jumps] = row[:to].split(',').map(&:to_i)
      end

      output = data.each_with_object({}) do |(id, r), map|
        map[id] = [
          r[:name],
          r[:regionID],
          r[:security],
          r[:beltCount],
          r[:ice] ? 1 : 0,
          r[:stations] || [],
          r[:agents] || [],
          r[:jumps] || []
        ]
      end

      write_file 'solar_systems_static.json', output
    end

    task :regions do
      output = {}

      read_file('regions.json').each do |row|
        output[row[:regionID]] = row[:regionName]
      end

      write_file 'regions.json', output
    end

    task :corporations do
      output = {}

      read_file('corporations.json').each do |row|
        output[row[:corporationID]] = row[:corporationName]
      end

      write_file 'corporations.json', output
    end
  end

  desc "Convert seed files to public"
  task seed2public: %w(solar_systems regions corporations).map{ |t| "seed2public:#{t}" }
end
