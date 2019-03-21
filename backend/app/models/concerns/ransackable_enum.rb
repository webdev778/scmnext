module RansackableEnum
  extend ActiveSupport::Concern
  included do
    class << self
      def ransackable_enum(enum_definition)
        enum enum_definition

        enum_name = enum_definition.keys.first
        ransacker enum_name, formatter: proc { |v|
          value = self.send(enum_name.to_s.pluralize)[v]
          if value.blank?
            -1
          else
            value
          end
        } do |parent|
          parent.table[enum_name]
        end
      end
    end
  end
end
