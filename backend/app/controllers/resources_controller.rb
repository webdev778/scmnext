class ResourcesController < ApplicationController
  include SimpleRestApi

  protected
  def params_for_save
    filtered_params = params
      .require(self.class.model_name.underscore)
      .permit(
        model_class.get_column_and_nested_attributes_permission
      )
  end
end
