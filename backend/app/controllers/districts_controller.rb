class DistrictsController < ApplicationController
  def index
    @q = District.ransack(params[:q])
    @districts = @q.result
    if params[:page].nil?
      @districts = @districts
      render json: @districts
    else
      @districts = @districts.page(params[:page])
      render json: {
        records: @districts,
        pages: {
          total_count: @districts.total_count,
          current_page: @districts.current_page,
          per_page: @districts.limit_value
        }
      }
    end
  end
end
