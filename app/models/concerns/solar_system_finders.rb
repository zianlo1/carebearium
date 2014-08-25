module SolarSystemFinders
  INDUSTRIAL_INDEX_COLUMNS = %w(manufacturing_index research_te_index research_me_index copying_index reverse_engineering_index invention_index)

  extend ActiveSupport::Concern

  module ClassMethods
    def security(options)
      if options[:min] && options[:max]
        min = options[:min].to_f / 100
        max = options[:max].to_f / 100
        where security: min..max
      else
        self
      end
    end

    def belts(options)
      if options[:min] && options[:max]
        where belt_count: options[:min]..options[:max]
      else
        self
      end
    end

    def stations(options)
      if options[:min] && options[:max]
        where stations_count: options[:min]..options[:max]
      else
        self
      end
    end

    def agents(options)
      if options[:min] && options[:max]
        where agents_count: options[:min]..options[:max]
      else
        self
      end
    end

    def region(options)
      if options[:name]
        where region_name: options[:name]
      else
        self
      end
    end

    def specific_agents(options)
      base = all

      options.each do |id, params|
        agent_lookup = Agent.where(solar_system_id: SolarSystem.arel_table[:id])
        agent_lookup = agent_lookup.where(level: params[:level]) if params[:level]
        agent_lookup = agent_lookup.where(kind: params[:kind]) if params[:kind]
        agent_lookup = agent_lookup.joins(:corporation).where(corporations: { name: params[:corporation]}) if params[:corporation]

        base = base.where agent_lookup.exists
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
          self
        end
      end
    end
  end
end
