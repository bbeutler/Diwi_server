require 'generators/trim_scaffold/helpers/swagger_definition'
require 'generators/trim_scaffold/helpers/attribute_methods'

class TrimScaffoldGenerator < Rails::Generators::NamedBase
  argument :attributes, type: :array
  include Helpers::SwaggerDefinition
  include Helpers::AttributeMethods

  def call
    create_definition_file
    run_scaffold
  end

  private

  def run_scaffold
    generate "scaffold #{class_name} #{rails_scaffold_attributes_args}"
  end
end
