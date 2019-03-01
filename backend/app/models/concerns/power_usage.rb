module PowerUsage
  extend ActiveSupport::Concern
  included do
    belongs_to :facility_group

    validates :facility_group_id,
              presence: true

    #
    # 時間枠ごとの合計を返す
    #
    scope :total_by_time_index, lambda {
      eager_load(:facility_group)
        .group(:time_index_id)
        .sum('value')
    }

    #
    # 全ての合計を返す
    #
    scope :total, lambda {
      eager_load(:facility_group)
        .sum('value')
    }

    class << self
      #
      # データの区分を返す
      # @return [Symbol] preliminary or fixed
      def data_type
        class_name.to_s.underscore.sub(/power_usage_/, '').to_sym
      end
    end
  end
end
