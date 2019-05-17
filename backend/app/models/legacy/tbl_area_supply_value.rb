# == Schema Information
#
# Table name: tbl_area_supply_value
#
#  id                 :integer          unsigned, not null, primary key
#  pps_id             :integer          not null
#  district_id        :integer          not null
#  supplier_id        :integer          not null
#  time               :datetime         not null
#  value              :integer          not null
#  interchange_value  :integer
#  interchange_pps_id :integer
#  priority           :string(1)        default("1"), not null
#  reg_date           :datetime
#

class Legacy::TblAreaSupplyValue < Legacy
  self.table_name = "tbl_area_supply_value"

  enum supplier_id: {
    supplier_id_jbu: 1,
    supplier_id_jepx_spot: 2,
    supplier_id_jepx_1h: 3,
    supplier_id_etc: 4,
    supplier_id_fit: 5
  }

  class << self
    #
    # 旧システムのポジションデータから指定されたBGの指定された日のポジションを取得する
    #
    def generate_position_data(balancing_group_id, date)
      bg = BalancingGroup.find(balancing_group_id)
      logger.info("#{bg.name}のポジションデータを取り込みます")
      resources_map = resources_for_the_balancing_group_map(bg.id)
      old_plan = Occto::Plan.find_by(balancing_group_id: bg.id, date: date)
      if old_plan
        logger.info("取込済のデータがあるため削除")
        old_plan.destroy
      end
      plan = Occto::Plan.new(balancing_group_id: bg.id, date: date)
      plan_details = bg.bg_members.map do |bg_member|
        Time.zone = "GMT"
        supply_data = where(priority: "1")
          .where(pps_id: bg_member.company_id, district_id: bg.district_id)
          .where(["time >= ? and time <= ?", date.beginning_of_day, date.end_of_day])
        supply_data.inject([]) do |result, supply_datum|
          next result if supply_datum.supplier_id_jepx_spot? and supply_datum.value.to_i.zero? and supply_datum.interchange_value.to_i.zero?
          next result if supply_datum.value.to_i.zero? and supply_datum.interchange_value.to_i.zero?
          resources = resources_map[supply_datum.supplier_id]
          raise "Cannot find resouce for balancing_group_id: #{bg.id} supplier_id: #{supply_datum.supplier_id}" if resources.blank?
          if resources.length > 1
            time = supply_datum.time
            time_index_id = TimeIndex.from_time_to_time_index_id(time)
            allocation_base_total = resources.sum{|resource| eval(resource.supply_value)}
            value_sum = 0
            interchange_value_sum = 0
            resources.each.with_index do |resource, index|
              if resources.length - 1 == index
                value = supply_datum.value - value_sum
                interchange_value = supply_datum.interchange_value - interchange_value_sum
              else
                value = supply_datum.value * eval(resource.supply_value) / allocation_base_total
                interchange_value = supply_datum.interchange_value * eval(resource.supply_value) / allocation_base_total
                value_sum += value
                interchange_value_sum += value
              end
              unless value.to_i.zero?
                result << new_resource_row(value, resource, supply_datum.time, bg_member)
              end
              # unless interchange_value.to_i.zero?
              #   result << new_resource_row(interchange_value, resources_map['supplier_id_self'].first, supply_datum.time, bg_member)
              # end
            end
          else
            resource = resources.first
            unless supply_datum.value.to_i.zero?
              result << new_resource_row(supply_datum.value, resource, supply_datum.time, bg_member)
            end
            unless supply_datum.interchange_value.to_i.zero?
              result << new_resource_row(supply_datum.interchange_value, resources_map['supplier_id_self'].first, supply_datum.time, bg_member)
            end
          end
          result
        end
      end.flatten.compact
      if plan_details.length > 0
        plan_details
          .group_by{|detail| detail[:bg_member_id]}
          .each do |bg_member_id, detail|
            pbbm = plan.plan_by_bg_members.build(bg_member_id: bg_member_id)
            demands = {}
            detail.each do |detail|
              demands[detail[:time_index_id]] ||= 0
              detail_base_data = detail.reject{|k, v| [:type, :bg_member_id].include?(k)}
              case detail[:type]
              when 'supply'
                demands[detail[:time_index_id]] += detail[:value]
                pbbm.plan_detail_supply_values.build(detail_base_data)
              when 'sales'
                demands[detail[:time_index_id]] -= detail[:value]
                pbbm.plan_detail_sale_values.build(detail_base_data)
              else
                raise "unknown detail type.#{detail[:type]}"
              end
            end
            demands.each do |time_index_id, value|
              pbbm.plan_detail_demand_values.build(time_index_id: time_index_id, value: value)
            end
          end
        plan.save!
        logger.info("取込完了")
      else
        logger.info("取込完了(データなし)")
      end
    end

    private
    def new_resource_row(value, resource, time, bg_member)
      {
        type: value > 0 ? 'supply' : 'sales',
        time_index_id: TimeIndex.from_time_to_time_index_id(time),
        bg_member_id: bg_member.id,
        resource_id: resource.id,
        value: value.abs
      }
    end

    def resources_for_the_balancing_group_map(balancing_group_id)
      Resource.where(balancing_group_id: balancing_group_id).map do |resource|
        supplier_id = case
        when resource.is_a?(ResourceJbu)
          "supplier_id_jbu"
        when resource.is_a?(ResourceJepxSpot)
          "supplier_id_jepx_spot"
        when resource.is_a?(ResourceJepxOneHour)
          "supplier_id_jepx_1h"
        when resource.is_a?(ResourceMatching)
          "supplier_id_etc"
        when resource.is_a?(ResourceFit)
          "supplier_id_fit"
        when resource.is_a?(ResourceSelf)
          "supplier_id_self"
        else
          raise "unknown resource #{resource.type}"
        end
        {supplier_id: supplier_id, resource: resource}
      end
      .group_by do |item|
        item[:supplier_id]
      end
      .map do |k, items|
        items = items.map{|i| i[:resource]}
        [k, items]
      end
      .to_h
    end
  end
end
