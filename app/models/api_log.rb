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

  def self.expire!(name)
    log name, 1.minute.ago
  end

  def self.call(name, lambda, finally: ->{})
    return unless expired? name

    api_response = lambda.call

    api_response[:rows].each do |row|
      begin
        yield row
      rescue Mongoid::Errors::DocumentNotFound
        next
      rescue => e
        Rails.logger.warn "#{e}, #{name} row: #{row}"
      end
    end

    finally.call

    ApiLog.log name, api_response[:expires_at]
  end
end
