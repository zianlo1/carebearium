class SolarSystemFinder
  def initialize
    @colllection = SolarSystem.all
    @fields      = {
      name:        { field: :name },
      region_name: { field: :region_name },
    }
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

  def to_json
    results = { fields: [], data: [] }

    @fields.each do |_, options|
      results[:fields] << { field: options[:field], title: options[:title] ? options[:title] : I18n.t("fields.#{options[:field]}") }
    end

    @colllection.each do |record|
      results[:data] << @fields.map do |_, options|
        options[:finder] ? options[:finder].call(record) : record.send(options[:field])
      end
    end

    results
  end

  private

  def find_by_region(options)
    if options[:name]
      @colllection = @colllection.where region_name: options['name']
    end
  end

  def find_by_jumps(options)
    return unless options[:system] && options[:system][:id] && options[:min] && options[:max]

    min = options[:min].to_i
    max = options[:max].to_i

    field = "distances.#{options[:system][:id].to_i}"
    @colllection = @colllection.between field => min..max
    @fields[field] = { field: field, finder: -> ss { ss[field] }, title: "Distance to #{options[:system][:name]}" }
  end

  def find_by_agent(options)
    queryable = { level: options[:level], kind: options[:division], corporation_name: options[:corporation] }
    queryable.reject!{ |k,v| v.blank? }

    return unless queryable.any?

    @colllection = @colllection.where :agents.to_sym.elem_match => queryable
    title = "Agents: #{queryable.values.join(' / ')}"
    @fields[title] = { field: title, finder: -> ss { ss.agents.where(queryable).count }, title: title }
  end

  SolarSystem::SCALED_FIELDS.each do |field, scale|
    define_method "find_by_#{field}" do |options|
      if options[:min] && options[:max]
        min = options[:min].to_f / scale
        max = options[:max].to_f / scale
        @colllection = @colllection.between field => min..max
        @fields[field] = { field: field, finder: -> ss { "%.#{Math.log10(scale).to_i}f" % ss[field] } }
      end
    end
  end
end
