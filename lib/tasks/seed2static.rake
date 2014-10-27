if Rails.env.development?
  require_relative 'task_helpers'

  namespace :seed2static do
    task :solar_systems do
      names = {}

      read_seed_file('solar_systems.json').each do |row|
        names[row[:id]] = row[:name]
      end

      write_static_data 'SolarSystemNames', names
    end

    task :agents do
      levels = Set.new
      divisions = Set.new

      read_seed_file('agents.json').each do |row|
        levels.add row[:level]
        divisions.add row[:division]
      end

      write_static_data 'AgentLevels', levels.to_a.sort

      division_map = {}
      divisions.to_a.sort.each_with_index do |division, index|
        division_map[index] = division
      end

      write_static_data 'AgentDivisions', division_map
    end

    task :corporations do
      output = {}

      read_seed_file('corporations.json').each do |row|
        output[row[:corporationID]] = row[:corporationName]
      end

      write_static_data 'Corporations', output
    end

    task :regions do
      output = {}

      read_seed_file('regions.json').each do |row|
        output[row[:regionID]] = row[:regionName]
      end

      write_static_data 'Regions', output
    end

    task :operations do
      output = {}

      read_seed_file('operations.json').each do |row|
        output[row[:id]] = row[:services].split(',').map(&:to_i).sort
      end

      write_static_data 'StationOperations', output
    end

    task :planet_types do
      output = {}

      read_seed_file('planets.json').each do |row|
        output[row[:typeID]] = row[:typeName].match(/Planet \((.*)\)/).captures[0]
      end

      write_static_data 'PlanetTypes', output
    end
  end

  desc "Convert seed files to static components"
  task seed2static: %w(solar_systems agents corporations regions operations planet_types).map{ |t| "seed2static:#{t}" }
end
