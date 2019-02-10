# == Schema Information
#
# Table name: occto_plans
#
#  id                 :bigint(8)        not null, primary key
#  balancing_group_id :bigint(8)
#  date               :date             not null
#  created_by         :integer
#  updated_by         :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Occto::Plan < ApplicationRecord
  has_many :plan_by_bg_members
  belongs_to :balancing_group

  accepts_nested_attributes_for :plan_by_bg_members

  class << self
    def import_data(filename)
      raise "ファイル[#{filename}]が見つかりません。" unless File.exists?(filename)
      zip_file = Zip::File.open(filename)
      doc = REXML::Document.new(zip_file.read(zip_file.entries.first.name), ignore_whitespace_nodes: :all)
      node_root = doc.elements['SBD-MSG/JPMGRP/JPTRM']
      bg = BalancingGroup.find_by(code: node_root.elements['JP06360'].text)
      date = DateTime.strptime(node_root.elements['JP06171'].text, "%Y%m%d")
      plan_attributes = {
        balancing_group_id: bg.id,
        date: date
      }
      plan_attributes[:plan_by_bg_members_attributes] = node_root.elements['JPM00022'].to_a.map do |node_by_company|
        bg_member = bg.bg_members.find{|bgm| bgm.code == node_by_company.elements['JP06316'].text}
        binding.pry if bg_member.nil?
        plan_detail_demands = node_by_company.elements['JPM00023/JPMR00023/JPM00024'].to_a.map do |node_demand_with_time_index|
          {
            time_index_id: node_demand_with_time_index.elements['JP06219'].text.to_i,
            value: node_demand_with_time_index.elements['JP06376'].text
          }
        end
        plan_detail_supplies = node_by_company.elements['JPM00027/JPMR00027/JPM00029'].to_a.map do |node_supply|
          resource = bg.resources.find_by(code: node_supply.elements['JP06366'].text)
          node_supply.elements['JPM00030'].to_a.map do |node_supply_with_time_index|
            {
              resource_id: resource.id,
              time_index_id: node_supply_with_time_index.elements['JP06219'].text.to_i,
              value: node_supply_with_time_index.elements['JP06369'].text
            }
          end
        end.flatten
        plan_detail_sales = node_by_company.elements['JPM00031/JPMR00031/JPM00033'].to_a.map do |node_sales|
          resource = bg.resources.find_by(code: node_sales.elements['JP06366'].text)
          node_sales.elements['JPM00034'].to_a.map do |node_sales_with_time_index|
            {
              resource_id: resource.id,
              time_index_id: node_sales_with_time_index.elements['JP06219'].text.to_i,
              value: node_sales_with_time_index.elements['JP06319'].text
            }
          end
        end.flatten
        {
          bg_member_id: bg_member.id,
          plan_detail_demand_values_attributes: plan_detail_demands,
          plan_detail_supply_values_attributes: plan_detail_supplies,
          plan_detail_sale_values_attributes: plan_detail_sales,
        }
      end
      self.create!(plan_attributes)
    end
  end
end
