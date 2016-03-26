module Mint2qif
  module Arguments
    def self.valid?
      return false unless input_file && output_directory
      File.exists?(input_file) && Dir.exists?(output_directory)
    end

    def self.input_file
      return unless input = ARGV.detect do |arg|
        arg["-i"]
      end
      ARGV[ARGV.index("-i") + 1]
    end

    def self.output_directory
      return unless input = ARGV.detect do |arg|
        arg["-o"]
      end
      ARGV[ARGV.index("-o") + 1]
    end

    def self.custom_categories_file
      return unless input = ARGV.detect do |arg|
        arg["-c"]
      end
      input.split("-c").last.strip
    end

    def self.invalid?
      !valid?
    end

    def self.help?
      ARGV.first.downcase.include?("help")
    end
  end
end