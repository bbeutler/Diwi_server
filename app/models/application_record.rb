class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

# Overrides default rails behavior of raising argument error
# if enum input does not match enum keys
# Solution from: https://github.com/rails/rails/issues/13971
module ActiveRecord
  module Enum
    class EnumType < Type::Value
      def assert_valid_value(value)
        unless value.blank? || mapping.has_key?(value) || mapping.has_value?(value)
          nil
        end
      end
    end
  end
end
