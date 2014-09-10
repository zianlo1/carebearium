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

  def order_by(params)
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
      results[:fields] << {
        field:     options[:field],
        title:     options[:title] ? options[:title] : I18n.t("fields.#{options[:field]}"),
        orderable: options.has_key?(:orderable) ? options[:orderable] : true
      }
    end

    @colllection.each do |record|
      results[:data] << @fields.map do |_, options|
        options[:finder] ? options[:finder].call(record) : record.send(options[:field])
      end
    end

    results
  end

  def self.constraints
    Rails.cache.fetch "SolarSystemFinder#constraints/#{SolarSystem.max(:updated_at).to_i}" do
      constraints = {}

      SolarSystem::SCALED_FIELDS.map do |field, scale|
        constraints[field] = {
          title: I18n.t("filters.#{field}"),
          min:   (SolarSystem.min(field) * scale).to_i,
          max:   (SolarSystem.max(field) * scale).to_i,
          scale: scale
        }
      end

      constraints[:region] = {
        title:        I18n.t('filters.region'),
        region_names: SolarSystem.distinct(:region_name).sort
      }

      constraints[:agent] = {
        title:        I18n.t('filters.agent'),
        divisions:    SolarSystem.distinct('agents.kind').sort,
        levels:       SolarSystem.distinct('agents.level').sort,
        corporations: SolarSystem.distinct('agents.corporation_name').sort,
        multi:        true
      }

      constraints[:jumps] = {
        title: I18n.t('filters.jumps'),
        min:   0,
        max:   50,
        multi: true
      }

      constraints[:station_service] = {
        title:    I18n.t('filters.station_service'),
        services: Station::SERVICE_FIELDS.each_with_object({}){ |field,map| map[field] = I18n.t("model.station.#{field}")},
        multi:    true
      }

      constraints
    end
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
    @fields[title] = { field: title, finder: -> ss { ss.agents.where(queryable).count }, title: title, orderable: false }
  end

  def find_by_station_service(options)
    return unless Station::SERVICE_FIELDS.include?(options[:key])

    @colllection = @colllection.where "stations.#{options[:key]}" => true
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
