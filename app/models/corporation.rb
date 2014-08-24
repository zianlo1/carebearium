class Corporation < ActiveRecord::Base
  has_many :agents, inverse_of: :corporation
end

# == Schema Information
#
# Table name: corporations
#
#  id   :integer          not null, primary key
#  name :string(255)
#
