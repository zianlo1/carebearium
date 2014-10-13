class SolarSystemOwner
  include Mongoid::Document
  include Mongoid::Timestamps::Updated

  field :name, type: String

  def self.update_names
    current_owner_ids = SolarSystem.distinct(:owner_id).compact

    nin(id: current_owner_ids).delete_all

    # EvE API is limited to 250 ids / call
    current_owner_ids.each_slice(250) do |ids|
      EveApi.names(ids)[:rows].each do |row|
        find_or_initialize_by(id: row['characterID']).update_attributes(name: row['name'])
      end
    end
  end

  def self.names
    all.each_with_object({}) do |owner, map|
      map[owner.id] = owner.name
    end
  end
end
