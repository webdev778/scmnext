class BalancingsController < ApplicationController
  def show
    bg_member = BgMember.joins(:balancing_group).find(params[:bg_member_id])
    plan_matrix = Occto::Plan.matrix_by_time_index_and_resouce_type(bg_member_id: params[:bg_member_id], date: params[:date])
    plan_matrix ||= {}
    power_usage_class = "power_usage_#{params[:type]}".camelize.constantize
    power_usage_matrix = power_usage_class
                         .where(
                           "facility_groups.district_id" => bg_member.balancing_group.district_id,
                           "facility_groups.company_id" => bg_member.company_id,
                           "date" => params[:date]
                         )
                         .total_by_time_index
                         .map { |k, v| [k, { usage: v }] }
                         .to_h
    result = plan_matrix.deep_merge(power_usage_matrix).map { |k, v| { time_index_id: k }.merge(v) }
    render json: result
  end
end
