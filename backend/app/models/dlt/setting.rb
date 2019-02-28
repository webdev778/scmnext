# == Schema Information
#
# Table name: dlt_settings
#
#  id          :bigint(8)        not null, primary key
#  company_id  :bigint(8)
#  district_id :bigint(8)
#  state       :integer          default(0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Dlt::Setting < ApplicationRecord
  belongs_to :company
  belongs_to :district
  has_many :files, class_name: 'Dlt::File'

  #
  # 託送への接続情報を取得
  #
  def connection
    return @con unless @con.nil?

    district = self.district
    pkcs12 = company.company_account_occto.pkcs12_object
    @con = Faraday::Connection.new(
      url: district.dlt_host,
      ssl: {
        client_key: pkcs12.key,
        client_cert: pkcs12.certificate
      }
    )
    @con
  end

  #
  # 指定されたデータ区分、日付、時間枠(当日データのみ)に一致するダウンロードデータを高圧・低圧とも検索し
  # 取込処理を実行する
  #
  def get_xml_object_and_process_high_and_low(data_type, date, time_index = nil)
    %i[high low].each do |voltage_class|
      files.filter_by_filename(data_type, voltage_class, date, time_index).each do |row|
        logger.debug(row.filename)
        row.perform_document_read do |doc|
          yield(row, doc, voltage_class)
        end
      end
    end
  end
end
