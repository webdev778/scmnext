# == Schema Information
#
# Table name: occto_fit_plans
#
#  id                         :bigint(8)        not null, primary key
#  bg_member_id               :bigint(8)
#  date                       :date             not null
#  initialized_at             :datetime
#  received_at                :datetime
#  send_at                    :datetime
#  fit_id_text                :string(23)
#  stat                       :string(1)
#  fit_receipt_stat           :string(2)
#  occto_last_update_datetime :datetime
#  occto_submit_datetime      :datetime
#  ottot_create_datetime      :datetime
#  created_by                 :integer
#  updated_by                 :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#

class Occto::FitPlan < ApplicationRecord
  has_many :fit_plan_by_power_generator_groups, dependent: :destroy
  belongs_to :bg_member

  enum stat: {
    "1" => 'stat_plan_registered',   # 発電計画詳細登録済
    "2" => 'stat_supply_registered', # 供給力（発電合計）登録済
    "3" => 'stat_sales_registered'   # 販売計画登録済み発電・販売計画提出済
  }

  enum fit_receipt_stat: {
    "03" => "fit_receipt_stat_pps_recieved",              # 受付済み(小売事業者)
    "04" => "fit_receipt_stat_wheeler_recieved",          # 受付済み(一般送配電事業者)
    "07" => "fit_receipt_stat_wait_for_pps_update",       # 小売事業者再確認/更新待ち
    "08" => "fit_receipt_stat_wait_for_wheeler_update",   # 一般送配電事業者再確認/更新待ち
    "11" => "fit_receipt_stat_received"                   # 計画提出済み
  }
end
