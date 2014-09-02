class SolarSystemFinder
  def initialize
    @colllection = SolarSystem.all
    @fields      = Set.new ['_id', 'name', 'region_name', 'security']
  end

  def find_by(params)
    return unless params.present?
    (JSON.parse(params) || {}).each do |idx, options|
      options = options.with_indifferent_access
      method_name = "find_by_#{options[:kind]}"
      if respond_to?(method_name, true)
        send method_name, options
      end
    end
    self
  end

  def sort_by(params)
    return unless params.present?
    (JSON.parse(params) || {}).each do |field, direction|
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

  def find_by_jumps(options)
    return unless options[:system] && options[:system][:id] && options[:min] && options[:max]

    min = options[:min].to_i
    max = options[:max].to_i

    field = "distances.#{options[:system][:id].to_i}"
    @colllection = @colllection.between "distances.#{options[:system][:id].to_i}" => min..max
    @fields.add "distances.#{options[:system][:id].to_i}"
  end

  def find_by_agent(options)
    queryable = { kind: options[:division], level: options[:level], corporation_name: options[:corporation] }
    queryable.reject!{ |k,v| v.blank? }

    return unless queryable.any?

    @colllection = @colllection.where :agents.to_sym.elem_match => queryable
    @fields.add "agents._id"
  end

  SolarSystem::SCALED_FIELDS.each do |field, scale|
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
