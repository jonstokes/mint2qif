module Mint2qif
  class Configuration
    include Virtus.model

    attribute :output_directory, String
    attribute :custom_categories_file, String

    def input_file
      @input_file
    end

    def input_file=(val)
      @input_file = val
    end

    def categories
      @categories ||= begin
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

    def default_categories
      @default_categories ||= YAML.load_file(File.join(Mint2qif.root, "lib", "mint2qif", "categories.yml"))
    end

    def custom_categories
      @custom_categories ||= if custom_categories_file
        YAML.load_file(custom_categories_file)
      else
        {}
      end
    end

  end
end