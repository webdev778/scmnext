class AddFacilityGroupIdToDltUsageFixedHeaders < ActiveRecord::Migration[5.2]
  def change
    add_reference :dlt_usage_fixed_headers, :facility_group, index: true, after: :id, comment: "施設グループID"
    unless reverting?
      Dlt::UsageFixedHeader.find_each do |usage_fixed_header|
        usage_fixed_header.set_facility_group_id!
      end
    end
  end
end
