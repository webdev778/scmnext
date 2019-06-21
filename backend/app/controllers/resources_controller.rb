class ResourcesController < ApplicationController
  include SimpleRestApi

  protected
  def params_for_save
    filtered_params = params
      .require(self.class.model_name.underscore)
      .permit(
        model_class.get_column_and_nested_attributes_permission
      )
    model_class.parameter_to_nested_attribute_data(filtered_params)
  end
end
