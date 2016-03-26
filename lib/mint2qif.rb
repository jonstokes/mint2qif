require 'virtus'
require 'qif'

require "mint2qif/version"
require "mint2qif/configuration"
require "mint2qif/csv_converter"
require "mint2qif/field_text"
require "mint2qif/category"
require "mint2qif/transaction"
require "mint2qif/arguments"

module Mint2qif
  def self.root
    File.dirname __dir__
  end

  def self.convert
    converter = Mint2qif::CsvConverter.new
    converter.split_accounts
    converter.write_files
  end

  def self.configure
    yield configuration
  end

  def self.configuration
    @configuration ||= Mint2qif::Configuration.new
  end
end
