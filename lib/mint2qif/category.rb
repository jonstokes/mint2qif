require 'yaml'

module Mint2qif
  class Category < Virtus::Attribute
    def coerce(value)
      value.strip!
      return value if categories.keys.include?(value)
      raise "Unknown category #{value}" unless category = categories.detect { |k, v| v.include?(value) }
      "#{category.first}:#{value}"
    end

    def categories
      Mint2qif::Category.categories
    end

    def self.categories
      @@categories ||= YAML.load_file(File.join(Mint2qif.root, "lib", "mint2qif", "categories.yml"))
    end
  end
end