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
    if company.company_account_occto.nil?
      logger.error("#{company.name}の広域アカウント情報がありません。")
      return nil
    end
    if company.company_account_occto.pkcs12_object.nil?
      logger.error("#{company.name}の広域アカウント情報の証明書を読み込むことができません。")
      return nil
    end

    district = self.district
    pkcs12 = company.company_account_occto.pkcs12_object
    @con = Faraday::Connection.new(
      url: district.dlt_host,
      ssl: {
        client_key: pkcs12.key,
        client_cert: pkcs12.certificate
      }
    )
  end

  #
  # PPSエリア別コードを返す
  #
  def company_area_code
    company.code + district.code_1digit
  end

  #
  # 託送データ取得用urlのprefixを返す
  # (dlt_pathに:company_area_codeとある場合のみPPSエリア別コードに置換する)
  #
  def path_prefix
    district.dlt_path.gsub(':company_area_code', company_area_code)
  end

  #
  # 指定されたデータ区分、日付、時間枠(当日データのみ)に一致するダウンロードデータを高圧・低圧とも検索し
  # 取込処理を実行する
  #
  def get_xml_object_and_process_high_and_low(data_type, date, time_index = nil)
    %i[high low].each do |voltage_class|
      files.filter_by_filename(data_type, voltage_class, date, time_index).each do |row|
        logger.debug(row.content.filename)
        row.perform_document_read do |doc|
          yield(row, doc, voltage_class)
        end
      end
    end
  end
end
