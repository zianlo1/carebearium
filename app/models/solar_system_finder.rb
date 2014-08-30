class SolarSystemFinder
  INDUSTRIAL_INDEX_FIELDS = %w(manufacturing_index research_te_index research_me_index copying_index reverse_engineering_index invention_index)

  SLIDER_FIELDS = {
    manufacturing_index:        1000,
    research_te_index:          1000,
    research_me_index:          1000,
    copying_index:              1000,
    reverse_engineering_index:  1000,
    invention_index:            1000,
    security:                   10,
    agents_count:               1,
    stations_count:             1,
    belts_count:                1
  }

  def initialize
    @colllection = SolarSystem.all
    @fields      = Set.new ['_id', 'name', 'region_name']
  end

  def find_by(params)
    (params || {}).each do |kind, options|
      method_name = "find_by_#{kind}"
      if respond_to?(method_name, true)
        send method_name, JSON.parse(options).with_indifferent_access
      end
    end
    self
  end

  def sort_by(params)
    (params || {}).each do |field, direction|
      direction = direction.downcase
      next unless %w(asc desc).include? direction
      @colllection = @colllection.order field.to_sym.send(direction)
    end
    self
  end

  def limit(amount)
    @colllection = @colllection.limit amount
    self
  end

  def to_a
    @colllection.only(*@fields).to_a
  end

  private

  def find_by_region(options)
    if options[:name]
      @colllection = @colllection.where region_name: options['name']
      @fields.add 'region_name'
    end
  end

  def find_by_jumps(params)
    params.each do |id, options|
      next unless options[:system] && options[:system][:id] && options[:min] && options[:max]

      min = options[:min].to_i
      max = options[:max].to_i

      field = "distances.#{options[:system][:id].to_i}"
      @colllection = @colllection.between "distances.#{options[:system][:id].to_i}" => min..max
      @fields.add "distances.#{options[:system][:id].to_i}"
    end
  end

  def find_by_specific_agents(params)
    params.each do |id, options|
      queryable = { kind: options[:kind], level: options[:level], corporation_name: options[:corporation] }
      queryable.reject!{ |k,v| v.blank? }
      @colllection = @colllection.where 'stations.agents'.to_sym.elem_match => queryable
      @fields.add "stations.agents._id"
    end
  end

  SLIDER_FIELDS.each do |field, scale|
    define_method "find_by_#{field}" do |options|
      if options[:min] && options[:max]
        min = options[:min].to_f / scale
        max = options[:max].to_f / scale
        @colllection = @colllection.between field => min..max
        @fields.add field
      end
    end
  end
end
