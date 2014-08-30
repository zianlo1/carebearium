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
        send method_name, JSON.parse(options)
      else
        Rails.logger.debug method_name
        Rails.logger.debug JSON.parse(options)
      end
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
    if options['name']
      @colllection = @colllection.where region_name: options['name']
      @fields.add 'region_name'
    end
  end

  SLIDER_FIELDS.each do |field, scale|
    define_method "find_by_#{field}" do |options|
      if options['min'] && options['max']
        min = options['min'].to_f / scale
        max = options['max'].to_f / scale
        @colllection = @colllection.between field => min..max
        @fields.add field
      end
    end
  end
end

#   def specific_agents(options)
#     return all_scope unless options.any?
#
#     options.map do |id, params|
#       agent_lookup = Agent.where(solar_system_id: SolarSystem.arel_table[:id])
#       agent_lookup = agent_lookup.where(level: params[:level]) if params[:level]
#       agent_lookup = agent_lookup.where(kind: params[:kind]) if params[:kind]
#       agent_lookup = agent_lookup.joins(:corporation).where(corporations: { name: params[:corporation]}) if params[:corporation]
#       agent_lookup
#     end.inject(all_scope) do |base, scope|
#       base.where scope.exists
#     end
#   end
#
#   def jumps(options)
#     base = all_scope
#
#     options.map do |id, params|
#       next unless params[:system] && params[:min] && params[:max]
#
#       base = base.where "(jumps->>:system)::int BETWEEN :min AND :max", system: params[:system][:id].to_s, min: params[:min].to_i, max: params[:max].to_i
#     end
#
#     base
#   end
