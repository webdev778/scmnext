class ProfitsController < ActionController::Base
  # include ActionView::Layouts
  # include ActionController::MimeResponds
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
        render json: @summary.as_json(methods: [:facility_group_name])
      end
    end
  end

  def group_by_date
    model_class = "Pl::BaseDatum#{params[:type].camelize}".constantize
    start_date = params[:start_date]
    end_date = params[:end_date]
    relation_obj = model_class
      .where("facility_group_id"=>params[:facility_group_id])
      .where(["date >= ?", start_date])
      .where(["date <= ?", end_date])
    @summary = model_class.summary(relation_obj, [:facility_group_id, :date])
    render json: @summary.as_json(methods: [:facility_group_name])
  end

  def group_by_time_index
    model_class = "Pl::BaseDatum#{params[:type].camelize}".constantize
    date = params[:date]
    relation_obj = model_class
      .where("facility_group_id"=>params[:facility_group_id])
      .where(["date = ?", date])
    @summary = model_class.summary(relation_obj, [:facility_group_id, :time_index_id])
    render json: @summary.as_json(methods: [:facility_group_name])
  end

  private
  def summary_to_table(summary)
    {
      id: "基本情報・需要家ID",
      facility_group_name: "基本情報・需要家名",
      facility_group_name: "基本情報・需要家区分",
      facility_group_name: "基本情報・契約kw",
      facility_group_name: "基本情報・全量or部分",
      facility_group_name: "基本情報・損失率",
      facility_group_name: "基本情報・電力使用量(部分考慮)",
      facility_group_name: "基本情報・電力使用量(全量時)",
      facility_group_name: "基本情報・計画値",
      facility_group_name: "基本情報・損失量",
      facility_group_name: "基本情報・インバランス余剰量",
      facility_group_name: "基本情報・インバランス不足量",
      facility_group_name: "基本情報・力率",
      facility_group_name: "売上料金・基本料金",
      facility_group_name: "売上料金・従量料金",
      facility_group_name: "売上料金・燃料調整費",
      facility_group_name: "売上料金・合計",
      facility_group_name: "売上料金・kw単価",
      facility_group_name: "仕入量・JBU使用量",
      facility_group_name: "仕入量・JEPXスポット使用量",
      facility_group_name: "仕入量・JEPX一時間前使用量",
      facility_group_name: "仕入量・FIT使用量",
      facility_group_name: "仕入量・相対使用量",
      facility_group_name: "仕入料金・JBU基本",
      facility_group_name: "仕入料金・JBU従量",
      facility_group_name: "仕入料金・JBU燃料調整費",
      facility_group_name: "仕入料金・JEPXスポット料金",
      facility_group_name: "仕入料金・JEPX一時間前料金",
      facility_group_name: "仕入料金・FIT料金",
      facility_group_name: "仕入料金・相対料金",
      facility_group_name: "仕入料金・インバランス余剰金",
      facility_group_name: "仕入料金・インバランス不足金",
      facility_group_name: "仕入料金・託送基本料金",
      facility_group_name: "仕入料金・託送従量料金",
      facility_group_name: "仕入料金・合計",
      facility_group_name: "仕入料金・kw単価",
      facility_group_name: "利益・粗利益",
      facility_group_name: "利益・利益率",
      facility_group_name: "負荷・負荷率"
    }
  end
end
