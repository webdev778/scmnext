# == Schema Information
#
# Table name: holidays
#
#  id          :bigint(8)        not null, primary key
#  district_id :bigint(8)
#  date        :date
#  name        :string(255)
#  created_by  :integer
#  updated_by  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Holiday < ApplicationRecord
  belongs_to :district

  scope :filter_district_id, ->(district_id) {
    where(district_id: [district_id, nil])
  }

  scope :includes_for_index, lambda {
    includes([:district])
  }

  def as_json(options = {})
    if options.blank?
      options = {
        include: :district
      }
    end
    super options
  end

  class << self
    #
    # 指定されたエリアの休日を取得する
    #
    def get_list(district_id)
      self.filter_district_id(district_id).pluck(:date)
    end
  end
end
