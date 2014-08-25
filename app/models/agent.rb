class Agent < ActiveRecord::Base
  belongs_to :corporation,  counter_cache: true
  belongs_to :station,      counter_cache: true
  belongs_to :solar_system, counter_cache: true
end

# == Schema Information
#
# Table name: agents
#
#  id              :integer          not null, primary key
#  corporation_id  :integer
#  station_id      :integer
#  solar_system_id :integer
#  level           :integer
#  kind            :string(255)
#  locator         :boolean
#
