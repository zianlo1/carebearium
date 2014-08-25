module SolarSystemFinders
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

    %w(manufacturing_index research_te_index research_me_index copying_index reverse_engineering_index invention_index).each do |industry_index|
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
