class ProfitsController < ActionController::Base
  def group_by_time_index
    model_class = "Pl::BaseDatum#{params[:type].camelize}".constantize
    relation_obj = model_class
      .where("facility_group_id"=>params[:facility_group_id])
      .where("date"=>params[:date])
    summary = model_class.summary(relation_obj, [:facility_group_id, :date, :time_index_id])
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
        render json: summary.as_json
      end
    end
  end

  def group_by_date
    model_class = "Pl::BaseDatum#{params[:type].camelize}".constantize
    year = params[:target_year_month][0, 4].to_i
    month = params[:target_year_month][4, 2].to_i
    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month
    relation_obj = model_class
      .where("facility_group_id"=>params[:facility_group_id])
      .where(["date >= ?", start_date])
      .where(["date <= ?", end_date])
    summary = model_class.summary(relation_obj, [:facility_group_id, :date])
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
        render json: summary.as_json
      end
    end
  end

  def group_by_facility_group_id
    model_class = "Pl::BaseDatum#{params[:type].camelize}".constantize
    year = params[:target_year_month][0, 4].to_i
    month = params[:target_year_month][4, 2].to_i
    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month
    relation_obj = model_class
      .where("facility_groups.bg_member_id"=>params[:bg_member_id])
      .where(["date >= ?", start_date])
      .where(["date <= ?", end_date])
    summary = model_class.summary(relation_obj, [:facility_group_id])
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
        render json: summary.as_json(methods: [:facility_group_name])
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
