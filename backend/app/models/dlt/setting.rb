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
  include RansackableEnum
  # don't use this relation.
  # belongs_to :company
  # belongs_to :district
  belongs_to :bg_member, required: false
  has_many :files, class_name: Dlt::File.to_s

  ransackable_enum state: {
    state_active: 0,
    state_stop: 1
  }

  scope :filter_state_active, lambda {
    where(state: :state_active)
  }

  scope :filter_id_unless_nil, lambda { |setting_id = nil|
    unless setting_id.nil?
      where(id: setting_id)
    end
  }

  scope :includes_for_index, lambda {
    includes(bg_member: [:company, {balancing_group: :district}])
  }

  def as_json(options = {})
    if options.blank?
      options = {
        methods: [
          :state_i18n
        ],
        include: {
          bg_member: {
            include:
              [
                :company,
                {
                  balancing_group: {
                    include: :district
                  }
                }
              ]
          }
        }
      }
    end
    super options
  end

  #
  # 託送への接続情報を取得
  #
  def connection
    return @con unless @con.nil?

    if bg_member.company.company_account_occto.nil?
      logger.error("#{company.name}の広域アカウント情報がありません。")
      return nil
    end
    if bg_member.company.company_account_occto.pkcs12_object.nil?
      logger.error("#{bg_member.company.name}の広域アカウント情報の証明書を読み込むことができません。")
      return nil
    end

    pkcs12 = bg_member.company.company_account_occto.pkcs12_object
    @con = Faraday::Connection.new(
      url: bg_member.balancing_group.district.dlt_host,
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
    bg_member.company.code + bg_member.balancing_group.district.code_1digit
  end

  #
  # 託送データ取得用urlのprefixを返す
  # (dlt_pathに:company_area_codeとある場合のみPPSエリア別コードに置換する)
  #
  def path_prefix
    bg_member.balancing_group.district.dlt_path.gsub(':company_area_code', company_area_code)
  end

end
