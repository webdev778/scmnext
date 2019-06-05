# == Schema Information
#
# Table name: pl_base_data
#
#  id                                :bigint(8)        not null, primary key
#  facility_group_id                 :bigint(8)
#  type                              :string(255)      not null
#  date                              :date             not null
#  time_index_id                     :bigint(8)        not null
#  amount_actual                     :decimal(10, 4)
#  amount_planned                    :decimal(10, 4)
#  amount_loss                       :decimal(10, 4)
#  amount_imbalance                  :decimal(10, 4)
#  power_factor_rate                 :decimal(10, 4)
#  sales_basic_charge                :decimal(10, 4)
#  sales_meter_rate_charge           :decimal(10, 4)
#  sales_fuel_cost_adjustment        :decimal(10, 4)
#  sales_cost_adjustment             :decimal(10, 4)
#  sales_special_discount            :decimal(10, 4)
#  usage_jbu                         :decimal(10, 4)
#  usage_jepx_spot                   :decimal(10, 4)
#  usage_jepx_1hour                  :decimal(10, 4)
#  usage_fit                         :decimal(10, 4)
#  usage_matching                    :decimal(10, 4)
#  supply_jbu_basic_charge           :decimal(10, 4)
#  supply_jbu_meter_rate_charge      :decimal(10, 4)
#  supply_jbu_fuel_cost_adjustment   :decimal(10, 4)
#  supply_jepx_spot                  :decimal(10, 4)
#  supply_jepx_1hour                 :decimal(10, 4)
#  supply_fit                        :decimal(10, 4)
#  supply_matching                   :decimal(10, 4)
#  supply_imbalance                  :decimal(10, 4)
#  supply_wheeler_fundamental_charge :decimal(10, 4)
#  supply_wheeler_meter_rate_charge  :decimal(10, 4)
#  created_by                        :integer
#  updated_by                        :integer
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#

class Pl::BaseDatum < ApplicationRecord
  belongs_to :facility_group

  class << self
    # ユビニティ使用分を除くための暫定処理用
    def ubnity_resource_map
      {
        1=>{1=>192,3=>300,2=>50,9=>50},
        2=>{1=>183,3=>300,2=>50,9=>50},
        3=>{1=>176,3=>300,2=>50,9=>50},
        4=>{1=>168,3=>300,2=>50,9=>50},
        5=>{1=>160,3=>300,2=>50,9=>50},
        6=>{1=>157,3=>300,2=>50,9=>50},
        7=>{1=>159,3=>300,2=>50,9=>50},
        8=>{1=>163,3=>300,2=>50,9=>50},
        9=>{1=>161,3=>300,2=>50,9=>50},
        10=>{1=>158,3=>300,2=>50,9=>50},
        11=>{1=>165,3=>300,2=>50,9=>50},
        12=>{1=>164,3=>300,2=>50,9=>50},
        13=>{1=>179,3=>300,2=>50,9=>50},
        14=>{1=>192,3=>300,2=>50,9=>50},
        15=>{1=>207,3=>300,2=>50,9=>50},
        16=>{1=>223,3=>300,2=>50,9=>50},
        17=>{1=>244,3=>500,2=>50,9=>50},
        18=>{1=>273,3=>500,2=>50,9=>50},
        19=>{1=>324,3=>500,2=>50,9=>50},
        20=>{1=>363,3=>500,2=>50,9=>50},
        21=>{1=>383,3=>500,2=>50,9=>50},
        22=>{1=>414,3=>500,2=>50,9=>50},
        23=>{1=>414,3=>500,2=>50,9=>50},
        24=>{1=>431,3=>500,2=>50,9=>50},
        25=>{1=>431,3=>500,2=>50,9=>50},
        26=>{1=>432,3=>500,2=>50,9=>50},
        27=>{1=>436,3=>500,2=>50,9=>50},
        28=>{1=>439,3=>500,2=>50,9=>50},
        29=>{1=>436,3=>500,2=>50,9=>50},
        30=>{1=>437,3=>500,2=>50,9=>50},
        31=>{1=>416,3=>500,2=>50,9=>50},
        32=>{1=>411,3=>500,2=>50,9=>50},
        33=>{1=>404,3=>500,2=>50,9=>50},
        34=>{1=>405,3=>500,2=>50,9=>50},
        35=>{1=>387,3=>500,2=>50,9=>50},
        36=>{1=>381,3=>500,2=>50,9=>50},
        37=>{1=>380,3=>300,2=>50,9=>50},
        38=>{1=>373,3=>300,2=>50,9=>50},
        39=>{1=>368,3=>300,2=>50,9=>50},
        40=>{1=>352,3=>300,2=>50,9=>50},
        41=>{1=>337,3=>300,2=>50,9=>50},
        42=>{1=>315,3=>300,2=>50,9=>50},
        43=>{1=>293,3=>300,2=>50,9=>50},
        44=>{1=>277,3=>300,2=>50,9=>50},
        45=>{1=>270,3=>300,2=>50,9=>50},
        46=>{1=>246,3=>300,2=>50,9=>50},
        47=>{1=>235,3=>300,2=>50,9=>50},
        48=>{1=>216,3=>300,2=>50,9=>50}
      }
    end

    #
    # 任意の日付、BGメンバーについて指定された使用量(速報値or確定値)を元に損益計算の元データを作成する
    #
    def generate_each_bg_member_data(date, bg_member, power_usage_class)
      # 使用量データを取得
      power_usage_relation = power_usage_class
                             .eager_load(facility_group: { supply_points: { facility: :discounts_for_facilities }, contract: :contract_basic_charges })
                             .where('facility_groups.bg_member_id': bg_member.id, date: date)
      # 対象データが無い場合はスキップ
      if power_usage_relation.count == 0
        logger.info "使用量データ未登録のためスキップしました。"
        return
      end
      max_demand_power_map = Facility.get_facility_group_id_max_demand_power_map_at(date)

      # ポジションデータを取得
      plan_matrix_by_time_index_and_resouce_type = Occto::Plan.balancing_group_matrix_by_time_index_and_resouce_type(balancing_group_id: bg_member.balancing_group_id, date: date)
      # ポジション未登録の場合もスキップ
      if plan_matrix_by_time_index_and_resouce_type.nil?
        logger.info "ポジションデータ未登録のためスキップしました。"
        return
      end

      # JBU契約を取得
      jbu_contract = bg_member.resource_jbu.jbu_contracts.where("start_date <= :date and (end_date IS NULL OR end_date <= :date)", date: Date.today).first

      # JBU契約未登録の場合スキップ
      if jbu_contract.nil?
        logger.info "JBU契約未登録のためスキップしました。"
        return
      end

      # 電圧区分ごとの燃料調整費・託送料データを取得する
      fuel_cost_adjustments_map_by_voltage_class = bg_member.fuel_cost_adjustments_at(date)
      wheeler_charges_map_by_voltage_class = bg_member.balancing_group.district.wheeler_charges_at(date)

      # 月当たりのコマ数を算出
      time_index_count = TimeIndex.time_index_count_of_month(date)

      # 当該BGメンバー全体の時間枠ごとの使用量をhash mapで取得
      total_by_time_index = power_usage_relation.total_by_time_index

      # 当日のエリアプライスデータを時間枠ごとのhash_mapに
      spot_trade_area_data_map_by_time_index = Jepx::SpotTradeAreaDatum.includes(:spot_trade)
        .where("jepx_spot_trades.date" => date, "district_id" => bg_member.balancing_group.district_id)
        .map do |spot_trade_area_datum|
          [spot_trade_area_datum.spot_trade.time_index_id, spot_trade_area_datum]
        end
        .to_h
      if spot_trade_area_data_map_by_time_index.count != 48
        raise "エリアプライスデータが未登録です"
      end

      # 需要家・コマごとの処理
      import_data = power_usage_relation.all.map do |power_usage|
        logger.debug "#{power_usage.facility_group.name} #{power_usage.date} #{power_usage.time_index_id}処理中"
        # PPS全体のその時間枠の使用量に対する需要家の使用量の割合を求める
        facility_power_usage_rate = power_usage.value / total_by_time_index[power_usage.time_index_id]

        # 当該コマのPPS全体の計画値(需要予測値を求める)
        total_demand = plan_matrix_by_time_index_and_resouce_type[power_usage.time_index_id]['demand']
        total_demand ||= 0
        bg_total_demand = total_demand
        if bg_member.company_id == 1 and ubnity_resource_map[power_usage.time_index_id][bg_member.balancing_group.district_id]
          # @todo このif文データを修正すれば不要となるので、uninity_resoure_mapと共に削除のこと
          total_demand = total_demand - ubnity_resource_map[power_usage.time_index_id][bg_member.balancing_group.district_id]
        end
        # 当該コマ・施設の計画値相当分を求める
        amount_planned = total_demand * facility_power_usage_rate

        # 供給リソースごとの使用量の割合を求める
        usage = %w[jepx_spot jepx_1hour jbu fit matching self].each_with_object({}) do |resource_type_name, usage|
          pps_usage_value = plan_matrix_by_time_index_and_resouce_type[power_usage.time_index_id][resource_type_name]
          pps_usage_value ||= 0
          pps_usage_value = pps_usage_value * total_demand / bg_total_demand
          usage[resource_type_name] = pps_usage_value * facility_power_usage_rate
        end

        fuel_cost_adjustment = fuel_cost_adjustments_map_by_voltage_class[power_usage.facility_group.voltage_type.to_voltage_class]
        fuel_cost_unit_price = fuel_cost_adjustment ? fuel_cost_adjustment.unit_price : 0
        loss_rate = 0.042
        amount_loss = power_usage.value * loss_rate
        amount_imbalance = amount_planned - (power_usage.value + amount_loss)

        if power_usage.facility_group.voltage_type.to_voltage_mode == :high
          electricity_value_contracted = max_demand_power_map[power_usage.facility_group.id]
          if electricity_value_contracted.nil?
            logger.warn("[#{power_usage.facility_group.id}] #{power_usage.facility_group.name}の契約電力を特定できません。")
            electricity_value_contracted = 0
          end
          sales_basic_charge = electricity_value_contracted * power_usage.facility_group.contract.basic_charge_at(date) * ((185.0 - 100.0) / 100) / time_index_count
        else
          sales_basic_charge = 0
        end
        {
          facility_group_id: power_usage.facility_group_id,
          date: date,
          time_index_id: power_usage.time_index_id,
          amount_actual: power_usage.value,
          amount_planned: amount_planned,
          amount_loss: amount_loss,
          amount_imbalance: amount_imbalance,
          power_factor_rate: 1,
          sales_basic_charge: sales_basic_charge,
          sales_meter_rate_charge: power_usage.facility_group.contract.meter_rate_at(date) * power_usage.value,
          sales_fuel_cost_adjustment: fuel_cost_unit_price * power_usage.value,
          sales_cost_adjustment: power_usage.facility_group.sales_cost_adjustment,
          sales_special_discount: power_usage.facility_group.sales_special_discount_rate_at(date),
          usage_jbu: usage['jbu'],
          usage_jepx_spot: usage['jepx_spot'],
          usage_jepx_1hour: usage['jepx_1hour'],
          usage_fit: usage['jepx_fit'],
          usage_matching: usage['matching'],
          supply_jbu_basic_charge: jbu_contract.basic_amount / time_index_count * facility_power_usage_rate,
          supply_jbu_meter_rate_charge: usage['jbu'] * jbu_contract.meter_rate_charge(date, power_usage.time_index_id),
          supply_jbu_fuel_cost_adjustment: usage['jbu'] * jbu_contract.fuel_cost_adjustment_charge,
          supply_jepx_spot: usage['jepx_spot'] * spot_trade_area_data_map_by_time_index[power_usage.time_index_id].area_price,
          supply_jepx_1hour: 0,
          supply_fit: 0,
          supply_matching: 0,
          supply_imbalance: amount_imbalance * spot_trade_area_data_map_by_time_index[power_usage.time_index_id].imbalance_unit_price(power_usage_class.data_type),
          supply_wheeler_fundamental_charge: wheeler_charges_map_by_voltage_class[power_usage.facility_group.voltage_type.to_voltage_class].basic_amount / time_index_count,
          supply_wheeler_meter_rate_charge: power_usage.value * wheeler_charges_map_by_voltage_class[power_usage.facility_group.voltage_type.to_voltage_class].meter_rate_charge
        }
      end
      import import_data
    end

    #
    # conditionsで指定された条件のデータをgroup_fields単位に集計しその結果を返す
    #
    # @param conditions [String | Array | Hash] データを絞り込む条件
    # @param group_fields [Array] 集計単位として使用するカラム名のリスト
    def summary(relation_obj, group_fields)
      select_items = group_fields + summary_columns.map do |col_name|
        "SUM(#{col_name}) AS #{col_name}"
      end
      relation_obj.joins(:facility_group).select(select_items).group(group_fields).distinct
    end

    #
    # 集計表で使用するアイテムの定義
    #
    def common_table_definitions_for_summary
      [
        {
          key: :id,
          category_label: "基本情報",
          label: "需要家ID"
        },
        {
          key: :facility_group_name,
          category_label: "基本情報",
          label: "需要家名"
        },
        {
          key: :facility_group_name,
          category_label: "基本情報",
          label: "需要家区分"
        },
        {
          key: :facility_group_name,
          category_label: "基本情報",
          label: "契約kw"
        },
        {
          key: :facility_group_name,
          category_label: "基本情報",
          label: "全量or部分"
        },
        {
          key: :facility_group_name,
          category_label: "基本情報",
          label: "損失率"
        },
        {
          key: :amount_actual,
          category_label: "基本情報",
          label: "電力使用量(部分考慮)"
        },
        {
          key: :amount_actual,
          category_label: "基本情報",
          label: "電力使用量(全量時)"
        },
        {
          key: :amount_planned,
          category_label: "基本情報",
          label: "計画値"
        },
        {
          key: :amount_loss,
          category_label: "基本情報",
          label: "損失量"
        },
        {
          key: :amount_imbalance,
          category_label: "基本情報",
          label: "インバランス余剰量"
        },
        {
          key: :amount_imbalance,
          category_label: "基本情報",
          label: "インバランス不足量"
        },
        {
          key: :amount_imbalance,
          category_label: "基本情報",
          label: "力率"
        },
        {
          key: :sales_basic_charge,
          category_label: "売上料金",
          label: "基本料金"
        },
        {
          key: :sales_meter_rate_charge,
          category_label: "売上料金",
          label: "従量料金"
        },
        {
          key: :sales_fuel_cost_adjustment,
          category_label: "売上料金",
          label: "燃料調整費"
        },
        {
          key: :sales_total,
          category_label: "売上料金",
          label: "合計"
        },
        {
          key: :sales_kw_unit_price,
          category_label: "売上料金",
          label: "kw単価"
        },
        {
          key: :usage_jbu,
          category_label: "仕入量",
          label: "JBU使用量"
        },
        {
          key: :usage_jepx_spot,
          category_label: "仕入量",
          label: "JEPXスポット使用量"
        },
        {
          key: :usage_jepx_1hour,
          category_label: "仕入量",
          label: "JEPX一時間前使用量"
        },
        {
          key: :usage_fit,
          category_label: "仕入量",
          label: "FIT使用量"
        },
        {
          key: :usage_matching,
          category_label: "仕入量",
          label: "相対使用量"
        },
        {
          key: :supply_jbu_basic_charge,
          category_label: "仕入料金",
          label: "JBU基本"
        },
        {
          key: :supply_jbu_meter_rate_charge,
          category_label: "仕入料金",
          label: "JBU従量"
        },
        {
          key: :supply_jbu_fuel_cost_adjustment,
          category_label: "仕入料金",
          label: "JBU燃料調整費"
        },
        {
          key: :supply_jepx_spot,
          category_label: "仕入料金",
          label: "JEPXスポット料金"
        },
        {
          key: :supply_jepx_1hour,
          category_label: "仕入料金",
          label: "JEPX一時間前料金"
        },
        {
          key: :supply_fit,
          category_label: "仕入料金",
          label: "FIT料金"
        },
        {
          key: :supply_matching,
          category_label: "仕入料金",
          label: "相対料金"
        },
        {
          key: :supply_imbalance,
          category_label: "仕入料金",
          label: "インバランス余剰金"
        },
        {
          key: :supply_imbalance,
          category_label: "仕入料金",
          label: "インバランス不足金"
        },
        {
          key: :supply_wheeler_fundamental_charge,
          category_label: "仕入料金",
          label: "託送基本料金"
        },
        {
          key: :supply_wheeler_meter_rate_charge,
          category_label: "仕入料金",
          label: "託送従量料金"
        },
        {
          key: :supply_total,
          category_label: "仕入料金",
          label: "合計"
        },
        {
          key: :supply_kw_unit_price,
          category_label: "仕入料金",
          label: "kw単価"
        },
        {
          key: :profit_value,
          category_label: "利益",
          label: "粗利益"
        },
        {
          key: :profit_rate,
          category_label: "利益",
          label: "利益率"
        },
        {
          key: :load_factor,
          category_label: "負荷",
          label: "負荷率"
        }
      ]
    end

    private

    #
    # 損益計算を集計する際、sumの対象になるカラム名の一覧
    # @return [Array] カラム名のリスト
    def summary_columns
      %i[
        amount_actual
        amount_planned
        amount_loss
        amount_imbalance
        sales_basic_charge
        sales_meter_rate_charge
        sales_fuel_cost_adjustment
        sales_cost_adjustment
        sales_special_discount
        usage_jbu
        usage_jepx_spot
        usage_jepx_1hour
        usage_fit
        usage_matching
        supply_jbu_basic_charge
        supply_jbu_meter_rate_charge
        supply_jbu_fuel_cost_adjustment
        supply_jepx_spot
        supply_jepx_1hour
        supply_fit
        supply_matching
        supply_imbalance
        supply_wheeler_fundamental_charge
        supply_wheeler_meter_rate_charge
      ]
    end
  end

  # @deprecated
  # 使用していない可能性が高いので確認後削除
  #
  # 設備グループ名
  # @return [String] 設備グループ名
  def facility_group_name
    facility_group.name
  end

  def sales_total
    [
      sales_basic_charge,
      sales_meter_rate_charge,
      sales_fuel_cost_adjustment,
      sales_cost_adjustment,
      sales_special_discount
    ].sum
  end

  def sales_kw_unit_price
    (sales_total / amount_actual)
  end

  def supply_total
    [
      supply_jbu_basic_charge,
      supply_jbu_fuel_cost_adjustment,
      supply_jepx_spot,
      supply_jepx_1hour,
      supply_fit,
      supply_matching,
      supply_imbalance,
      supply_wheeler_fundamental_charge,
      supply_wheeler_meter_rate_charge
    ].sum
  end

  def supply_kw_unit_price
    (supply_total / amount_actual)
  end

  def profit_value
    (sales_total - supply_total)
  end

  def profit_rate
    (profit_value / sales_total)
  end

  def load_factor
    0
  end

  def as_json(options = {})
    logger.debug(options)
    options = options.deep_merge({
      methods: [
        :sales_total,
        :sales_kw_unit_price,
        :supply_total,
        :supply_kw_unit_price,
        :profit_value,
        :profit_rate,
        :load_factor
      ]
    }) do |key, this_val, other_val|
      if this_val.is_a?(Array) and other_val.is_a?(Array)
        this_val + other_val
      else
        other_val
      end
    end
    super options
  end
end
