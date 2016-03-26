require 'yaml'

module Mint2qif
  class Category < Virtus::Attribute
    def coerce(value)
      value.strip!
      return value if categories.keys.include?(value)
      raise "Unknown category #{value}" unless category = categories.detect { |k, v| v && v.include?(value) }
      "#{category.first}:#{value}"
    end

    def categories
      Mint2qif.configuration.categories
    end
  end
end