module VoltageClass
  extend ActiveSupport::Concern

  included do
    enum voltage_class: {
      voltage_class_special_high: 1,
      voltage_class_high: 2,
      voltage_class_low: 3
    }
  end
end
