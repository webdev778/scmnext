class ProfitsController < ActionController::Base
  def list
    extra_fields = []
    unless params[:group_by_unit].is_a? Array
      params[:group_by_unit] = [params[:group_by_unit]]
    end
    relation_obj = "Pl::BaseDatum#{params[:type].camelize}".constantize
    if params[:date_from]
      relation_obj = relation_obj.where('date >= ?', params[:date_from])
    end
    if params[:date_to]
      relation_obj = relation_obj.where('date <= ?', params[:date_to])
    end
    if params[:time_index]
      relation_obj = relation_obj.where(time_index_id: params[:time_index_id])
    end
    if params[:facility_group_id]
      relation_obj = relation_obj.where(facility_group_id: params[:facility_group_id])
    end
    if params[:bg_member_id]
      relation_obj = relation_obj.where("facility_groups.bg_member_id"=>params[:bg_member_id])
    end

    if params[:group_by_unit].include?("facility_group_id")
      extra_fields << "facility_group_name"
    end

    summary = relation_obj.summary(relation_obj, params[:group_by_unit])
    respond_to do |format|
      format.csv do
        @table_data = summary_to_table(summary)
        render content_type: 'text/csv'
      end
      format.xlsx do
        @table_data = summary_to_table(summary)
        render content_type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
      end
      format.json do
        render json: summary.as_json(methods: extra_fields)
      end
    end
  end

  private
  def summary_to_table(summary)
    line = []
    line << Pl::BaseDatum.common_table_definitions_for_summary.map do |item|
      "#{item[:category_label]}・#{item[:label]}"
    end
    summary.each do |datum|
      line << Pl::BaseDatum.common_table_definitions_for_summary.map do |item|
        datum.send(item[:key])
      end
    end
    line
  end

end
