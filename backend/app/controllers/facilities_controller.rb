class FacilitiesController < ApplicationController
  def index
    @q = Facility.ransack(params[:q])
    @facilities = @q.result
    if params[:page].nil?
      @facilities = @facilities
      render json: @facilities
    else
      @facilities = @facilities.page(params[:page])
      render json: {
        records: @facilities,
        pages: {
          total_count: @facilities.total_count,
          current_page: @facilities.current_page,
          per_page: @facilities.limit_value
        }
      }
    end
  end

  def show
    @facility = Facility.find(params[:id])
    render json: @facility
  end

  def update
    @facility = Facility.find(params[:id])
    if @facility.update(params.require("facility").permit(Facility.column_names))
      render json: { result: :ok }
    else
      render json: { result: :error, errors: @facility.errors.full_messages }
    end
  end

end
