# == Schema Information
#
# Table name: time_indices
#
#  id         :bigint(8)        not null, primary key
#  time       :time
#  created_by :integer
#  updated_by :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TimeIndex < ApplicationRecord
  class << self
    def to_time_of_day(time_index)
      time_index = (time_index.to_i - 1)
      Tod::TimeOfDay.new(time_index / 2, (time_index % 2) * 30)
    end
  end
end
