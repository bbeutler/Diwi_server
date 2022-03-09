module Helpers
  module AttributeMethods
    def rails_scaffold_attributes_args
      generated_attributes_args = ''
      attributes.each do |a|
        generated_attributes_args << " #{a.name}:#{a.type}"
        generated_attributes_args << ':index' if a.has_index?
        generated_attributes_args << ':uniq' if a.has_uniq_index?
        generated_attributes_args << " #{a.attr_options}" unless a.attr_options.empty?
      end
      generated_attributes_args
    end
  end
end
