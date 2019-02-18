class ProfitsController < ApplicationController
  def show
    result = Pl::BaseDatumFixed.summary(nil, [:facility_group_id])
    render json: result.as_json({ methods: [:facility_group_name] })
  end
end
