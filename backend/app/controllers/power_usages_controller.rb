class PowerUsagesController < ApplicationController
  def show
    result = PowerUsagePreliminary
      .eager_load({facility: :consumer})
      .where('consumers.company_id'=>1)
      .where(date: '2018-12-25')
      .total_by_time_index
    render json: result
  end
end
