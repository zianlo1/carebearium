require 'multi_json'
require 'oj'

def read_seed_file(filename)
  MultiJson.load File.read(Rails.root.join 'db', 'seeds', filename), symbolize_keys: true
end

def write_seed_file(filename, content)
  File.open(Rails.root.join('db', 'seeds', filename), 'w') do |f|
    f.write(MultiJson.dump content, pretty: true)
  end
end

def write_static_data(header, data)
  File.open(Rails.root.join('app', 'assets', 'javascripts', 'data', "#{header.underscore}.coffee"), 'w') do |f|
    f.write("CB.StaticData.#{header} = #{MultiJson.dump data}")
  end
end
