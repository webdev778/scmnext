# == Schema Information
#
# Table name: jepx_imbalance_betas
#
#  id          :bigint(8)        not null, primary key
#  year        :integer          not null
#  month       :integer          not null
#  district_id :bigint(8)
#  value       :decimal(5, 2)
#  created_by  :integer
#  updated_by  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Jepx::ImbalanceBeta < ApplicationRecord
  belongs_to :district

  class << self
    def import
      puts "download!"
    end
  end
end
