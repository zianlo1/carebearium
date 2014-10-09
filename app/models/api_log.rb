class ApiLog
  include Mongoid::Document

  field :name,       type: String
  field :called_at,  type: ActiveSupport::TimeWithZone
  field :expires_at, type: ActiveSupport::TimeWithZone

  def self.log(name, expires)
    find_or_create_by(name: name).update_attributes(called_at: Time.current, expires_at: expires)
  end

  def self.expired?(name)
    record = where(name: name).first
    record.nil? || record.expires_at <= Time.current
  end
end
