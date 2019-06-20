class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  class << self
    def logger
      Rails.logger
    end

    def get_column_and_nested_attributes_permission
      attributes_of_this_class = column_names + ["_destroy"]
      attributes_of_nested_class = ([self] + subclasses).map do |klass|
        klass.nested_attributes_options.keys.map do |key|
          [key, klass.reflections[key.to_s].klass.get_column_and_nested_attributes_permission]
        end
        .to_h
      end.flatten
      if attributes_of_nested_class.empty?
        attributes_of_this_class
      else
        attributes_of_this_class + [attributes_of_nested_class]
      end
    end
  end

  def logger
    Rails.logger
  end

end
