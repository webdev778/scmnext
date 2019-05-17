class ProfitsController < ActionController::Base
  def group_by_time_index
    render_result([:facility_group_id, :date, :time_index_id]) do |relation_obj|
      relation_obj = relation_obj
        .where("facility_group_id"=>params[:facility_group_id])
        .where("date"=>params[:date])
    end
  end

  def group_by_date
    year = params[:target_year_month][0, 4].to_i
    month = params[:target_year_month][4, 2].to_i
    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month
    render_result([:facility_group_id, :date], [:facility_group_name]) do |relation_obj|
      relation_obj = relation_obj
      .where("facility_group_id"=>params[:facility_group_id])
      .where(["date >= ?", start_date])
      .where(["date <= ?", end_date])
    end
  end

  def group_by_facility_group_id
    year = params[:target_year_month][0, 4].to_i
    month = params[:target_year_month][4, 2].to_i
    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month
    render_result([:facility_group_id], [:facility_group_name]) do |relation_obj|
      relation_obj = relation_obj
        .where("facility_groups.bg_member_id"=>params[:bg_member_id])
        .where(["date >= ?", start_date])
        .where(["date <= ?", end_date])
        .preload("facility_group")
    end
  end


  private
  def render_result(group_keys, extra = [])
    model_class = "Pl::BaseDatum#{params[:type].camelize}".constantize
    relation_obj = model_class
    relation_obj = yield relation_obj
    summary = model_class.summary(relation_obj, group_keys)
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
        render json: summary.as_json(methods: extra)
      end
    end
  end

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
