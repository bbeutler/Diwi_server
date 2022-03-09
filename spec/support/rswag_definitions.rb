# Avoids repetitive schemas in multiple specs and keeps the
# swagger_helper file tidy by converting yaml files to definitions
module RswagDefinitions
  def model_schemas
    definitions_files = Dir["#{Rails.root}/spec/support/definitions/*.yml"]
    definitions_hash = {}

    definitions_files.each do |file_path|
      file = open_yaml_file(file_path)
      definitions_hash.merge!(definition_as_hash(file))
    end

    definitions_hash
  end

  private

  def open_yaml_file(file_path)
    File.open(file_path, 'rb', &:read)
  end

  def definition_as_hash(file)
    YAML.safe_load(file).deep_symbolize_keys
  end
end
