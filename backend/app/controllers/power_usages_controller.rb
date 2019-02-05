class PowerUsagesController < ApplicationController
  def show
    model_class = "power_usage_#{params[:type]}".camelize.constantize
    result = model_class
      .eager_load({facility: :consumer})
      .where('consumers.company_id'=>1)
      .where(date: params[:date])
      .total_by_time_index
    render json: result
  end
end
