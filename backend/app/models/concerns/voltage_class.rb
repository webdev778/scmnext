module VoltageClass
  extend ActiveSupport::Concern

  included do
    enum voltage_class: VoltageType::VOLTAGE_CLASS_MAPPING
  end
end
