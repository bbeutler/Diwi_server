module Helpers
  module SwaggerDefinition
    def create_definition_file
      create_file "spec/support/definitions/#{file_name}.yml", <<~FILE
        #{class_name.downcase}:
          type: object
          properties:
            id:
              type: integer
      FILE
    end
  end
end
