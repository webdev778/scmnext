module SimpleRestApi
  extend ActiveSupport::Concern

  included do
    include DeviseTokenAuth::Concerns::SetUserByToken

    before_action :authenticate_user!

    class_attribute :model_name
    self.model_name = self.to_s.gsub(/Controller$/, '').singularize
    def model_class
      self.model_name.constantize
    end

    respond_to :json
  end

  def index
    @q = model_class.ransack(params[:q])
    results = @q.result
    if params[:page].nil?
      render json: results
    else
      results = results.page(params[:page])
      results = results.per(params[:per]) unless params[:per].blank?
      render json: {
        records: results,
        pages: {
          total_count: results.total_count,
          current_page: results.current_page,
          per_page: results.limit_value
        }
      }
    end
  end

  def show
    instance = model_class.find(params[:id])
    render json: instance
  end

  def create
    instance = model_class.new(params_for_create)
    execute_action_and_send_result(instance) do |instance|
      instance.save
    end
  end

  def update
    instance = model_class.find(params[:id])
    execute_action_and_send_result(instance) do |instance|
      instance.update(params_for_update)
    end
  end

  def destroy
    instance = model_class.find(params[:id])
    execute_action_and_send_result(instance) do |instance|
      instance.destroy
    end
  end

  protected
  def params_for_save
    params
    .require(self.class.model_name.downcase)
    .permit(model_class.column_names)
  end

  def params_for_create
    params_for_save
  end

  def params_for_update
    params_for_save
  end

  private
  def execute_action_and_send_result(instance)
    if yield(instance)
      render json: { success: true }
    else
      render json: { success: false, errors: instance.errors.full_messages }
    end
  end
end
