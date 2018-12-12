# == Schema Information
#
# Table name: district_loss_rates
#
#  id                            :bigint(8)        not null, primary key
#  district_id(エリアID)            :bigint(8)
#  voltage_type_id(電圧種別ID)       :bigint(8)
#  rate(損失率)                     :float(24)
#  application_start_date(適用開始日) :date
#  application_end_date(適用終了日)   :date
#  created_by                    :integer
#  updated_by                    :integer
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#

class DistrictLossRate < ApplicationRecord
  belongs_to :voltage_type
end
