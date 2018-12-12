# == Schema Information
#
# Table name: time_indices
#
#  id           :bigint(8)        not null, primary key
#  time(時間)     :time
#  created_by   :integer
#  updated_by   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class TimeIndex < ApplicationRecord
end
