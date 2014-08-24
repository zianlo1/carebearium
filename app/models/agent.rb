class Agent < ActiveRecord::Base
  belongs_to :corporation
  belongs_to :station
  belongs_to :solar_system
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
