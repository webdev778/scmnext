#
# API共通処理
#
module SimpleRestApi
  extend ActiveSupport::Concern

  included do
    #include DeviseTokenAuth::Concerns::SetUserByToken

    before_action :authenticate_user!

    class_attribute :model_name
    self.model_name = to_s.gsub(/Controller$/, '').singularize

    def model_class
      model_name.constantize
    end

    respond_to :json
  end

  def index
    @q = model_class_with_includes(:index).ransack(params[:q])
    results = @q.result
    if params[:page].nil?
      render json: results
    else
      results = results.page(params[:page])
      results = results.per(params[:per]) if params[:per].present?
      render json: result_set_for_pagenated(results)
    end
  end

  def show
    instance = model_class_with_includes(:show).find(params[:id])
    render json: instance
  end

  def create
    instance = model_class.new(params_for_create)
    execute_action_and_send_result(instance, &:save)
  end

  def update
    instance = model_class_with_includes(:show).find(params[:id])
    execute_action_and_send_result(instance) do |i|
      i.update(params_for_update)
    end
  end

  def destroy
    instance = model_class_with_includes(:show).find(params[:id])
    execute_action_and_send_result(instance, &:destroy)
  end

  protected

  def params_for_save
    params
      .require(self.class.model_name.underscore)
      .permit(model_class.column_names)
  end

  def params_for_create
    params_for_save
  end

  def params_for_update
    params_for_save
  end

  private

  def result_set_for_pagenated(results)
    {
      records: results,
      pages: {
        total_count: results.total_count,
        current_page: results.current_page,
        per_page: results.limit_value
      }
    }
  end

  #
  # 指定したアクションを検索するためのスコープがある場合はそれを使用してActiveRecordRelationを取得する
  # (index[一覧用]/show[詳細用]のいずれかを想定)
  # 対象となるmodelにincludes_for_[アクション名]という名前のスコープがあればそれを使用
  #
  # @param [String/Symbol] action_type スコープの種別
  #
  def model_class_with_includes(action_type)
    method_name = "includes_for_#{action_type}"
    if model_class.respond_to?(method_name)
      model_class.send(method_name)
    else
      model_class
    end
  end

  def execute_action_and_send_result(instance)
    if yield(instance)
      render json: { success: true }
    else
      render json: { success: false, errors: instance.errors.full_messages }
    end
  end
end
