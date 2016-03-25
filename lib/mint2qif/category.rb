require 'yaml'

module Mint2qif
  class Category < Virtus::Attribute
    def coerce(value)
      value.strip!
      return value if categories.keys.include?(value)
      raise "Unknown category #{value}" unless category = categories.detect { |k, v| v.include?(value) }
      "#{category}:#{value}"
    end

    def self.categories
      @@categories ||= YAML.load_file("categories.yml")
    end
  end
end