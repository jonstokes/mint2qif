require 'yaml'

module Mint2qif
  class Category < Virtus::Attribute
    def coerce(value)
      search_value = value.strip.downcase
      if category = find_category(search_value)
        return category
      end
      raise "Unknown category #{value}"
    end

    def categories
      Mint2qif.configuration.categories
    end

    def find_category(value)
      category = nil
      subcategory = nil
      categories.each  do |primary, subcategories|
        next if category

        if primary.downcase == value
          category = primary
        elsif subcategories && subcategories.any?
          subcategories.each do |subcat|
            if subcat.is_a?(String)
              if subcat.downcase == value
                category = primary
                subcategory = subcat
              end
            else # cat is a hash
              mapped_subcategory_name = subcat.keys.first
              mappings = subcat[mapped_subcategory_name]
              if mapped_subcategory_name.downcase == value
                category = primary
                subcategory = mapped_subcategory_name
              else
                mappings.each do |mapping|
                  next unless mapping.downcase == value
                  category = primary
                  subcategory = mapped_subcategory_name
                end
              end
            end
          end
        end
      end
      return subcategory ? "#{category}:#{subcategory}" : category
    end
  end
end