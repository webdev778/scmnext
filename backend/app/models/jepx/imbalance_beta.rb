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
    def import_data
      conn = Faraday::Connection.new(:url => 'http://www.jepx.org') do |builder|
        builder.use Faraday::Request::UrlEncoded
        builder.use Faraday::Adapter::NetHttp
      end
      response = conn.get('market/excel/imbalance_beta.xlsx')
      workbook = RubyXL::Parser.parse_buffer(response.body)
      worksheet = workbook[0]
      start_date = Date.new(1900,1,1)
      i = 1
      j = 1
      rows = []
      while worksheet[i]
        delta = worksheet[i][0].value
        date = start_date + delta
        while worksheet[i][j] && j < 10
          #district = District.find_by(code: "0#{j}")
          rows << {year:date.year, month:date.month, district_id:j, value:worksheet[i][j].value}
          j += 1
        end
        i += 1
        j = 1
      end
      self.import(rows, { on_duplicate_key_update: [:value] })
    end
  end
end
