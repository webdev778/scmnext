# == Schema Information
#
# Table name: dlt_usage_fixed_details
#
#  id                    :bigint(8)        not null, primary key
#  usage_fixed_header_id :bigint(8)
#  date                  :date
#  time_index_id         :bigint(8)
#  usage_all             :decimal(10, 4)
#  usage                 :decimal(10, 4)
#  created_by            :integer
#  updated_by            :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class Dlt::UsageFixedDetail < ApplicationRecord
  belongs_to :usage_fixed_header
end
