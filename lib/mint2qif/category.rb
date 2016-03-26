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
      Mint2qif::Category.categories
    end

    def self.categories
      @@categories ||= begin
        cats = default_categories.dup
        custom_categories.each do |category, subcategories|
          next unless subcategories.any?
          cats[category] ||= []
          cats[category] += subcategories
          cats[category].uniq!
        end
        cats
      end
    end

    def self.default_categories
      @@default_categories ||= YAML.load_file(File.join(Mint2qif.root, "lib", "mint2qif", "categories.yml"))
    end

    def self.custom_categories
      @@custom_categories ||= if Mint2qif::Arguments.custom_categories_file
        YAML.load_file(Mint2qif::Arguments.custom_categories_file)
      else
        {}
      end
    end
  end
end