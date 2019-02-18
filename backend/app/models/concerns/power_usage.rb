module PowerUsage
  extend ActiveSupport::Concern
  included do
    belongs_to :facility_group

    validates :facility_group_id,
              presence: true

    scope :total_by_time_index, -> {
      eager_load(:facility_group)
        .group(:time_index_id)
        .sum("value")
    }

    scope :total, -> {
      eager_load(:facility_group)
        .sum("value")
    }
  end
end
