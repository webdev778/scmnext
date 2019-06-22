class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  class << self
    def logger
      Rails.logger
    end

    def json_option_for_index
      json_option
    end

    def json_option_for_show
      json_option
    end

    def json_option
      {}
    end

    #
    # nested_attributes指定された関連データを受け付けるようにstrongパラメータ用のpermissionを生成する
    #
    def get_column_and_nested_attributes_permission()
      result = attributes_of_this_class
      nesteds = {}
      ([self] + subclasses).each do |klass|
        klass.nested_attributes_options.keys.map do |nested_attribute_name|
          next unless klass.reflections[nested_attribute_name.to_s]
          nesteds[nested_attribute_name] = klass.reflections[nested_attribute_name.to_s].klass.get_column_and_nested_attributes_permission
        end
      end
      nesteds.empty? ? result : result + [nesteds]
    end

    #
    # nested_parameter用のデータに変換する
    #
    def parameter_to_nested_attribute_data(parameter)
      result = {}
      attributes_of_this_class.each do |field_name|
        next unless parameter[field_name.to_s]
        result[field_name] = parameter[field_name.to_s]
      end
      ([self] + subclasses).each do |klass|
        klass.nested_attributes_options.keys.each do |nested_attribute_name|
          next unless parameter[nested_attribute_name.to_s]
          case
          when klass.reflections[nested_attribute_name.to_s].is_a?(ActiveRecord::Reflection::HasManyReflection)
            result["#{nested_attribute_name}_attributes"] = []
            parameter[nested_attribute_name.to_s].each do |child_param|
              result["#{nested_attribute_name}_attributes"] << klass.reflections[nested_attribute_name.to_s].klass.parameter_to_nested_attribute_data(child_param)
            end
          else
            result["#{nested_attribute_name}_attributes"] = klass.reflections[nested_attribute_name.to_s].klass.parameter_to_nested_attribute_data(parameter[nested_attribute_name])
          end
        end
      end
      result
    end

    private
    def attributes_of_this_class(is_relation = false)
      attributes_of_this_class = column_names + ["_destroy"]
    end
  end

  def logger
    Rails.logger
  end

end
