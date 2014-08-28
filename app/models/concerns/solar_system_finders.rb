module SolarSystemFinders
  INDUSTRIAL_INDEX_COLUMNS = %w(manufacturing_index research_te_index research_me_index copying_index reverse_engineering_index invention_index)

  def all_scope
    where(id: SolarSystem.arel_table[:id])
  end

  def security(options)
    if options[:min] && options[:max]
      min = options[:min].to_f / 10
      max = options[:max].to_f / 10
      where security: min..max
    else
      all_scope
    end
  end

  def belts(options)
    if options[:min] && options[:max]
      where belt_count: options[:min]..options[:max]
    else
      all_scope
    end
  end

  def stations(options)
    if options[:min] && options[:max]
      where stations_count: options[:min]..options[:max]
    else
      all_scope
    end
  end

  def agents(options)
    if options[:min] && options[:max]
      where agents_count: options[:min]..options[:max]
    else
      all_scope
    end
  end

  def region(options)
    if options[:name]
      where region_name: options[:name]
    else
      all_scope
    end
  end

  def specific_agents(options)
    return all_scope unless options.any?

    options.map do |id, params|
      agent_lookup = Agent.where(solar_system_id: SolarSystem.arel_table[:id])
      agent_lookup = agent_lookup.where(level: params[:level]) if params[:level]
      agent_lookup = agent_lookup.where(kind: params[:kind]) if params[:kind]
      agent_lookup = agent_lookup.joins(:corporation).where(corporations: { name: params[:corporation]}) if params[:corporation]
      agent_lookup
    end.inject(all_scope) do |base, scope|
      base.where scope.exists
    end
  end

  def jumps(options)
    base = all_scope

    options.map do |id, params|
      next unless params[:system] && params[:min] && params[:max]

      base = base.where "(jumps->>:system)::int BETWEEN :min AND :max", system: params[:system].to_s, min: params[:min].to_i, max: params[:max].to_i
    end

    base
  end

  INDUSTRIAL_INDEX_COLUMNS.each do |industry_index|
    define_method industry_index do |options|
      if options[:min] && options[:max]
        min = options[:min].to_f / 1000
        max = options[:max].to_f / 1000
        where industry_index => min..max
      else
        all_scope
      end
    end
  end
end
