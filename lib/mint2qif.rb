require 'virtus'
require 'qif'

require "mint2qif/version"
require "mint2qif/csv_converter"
require "mint2qif/field_text"
require "mint2qif/category"
require "mint2qif/transaction"

module Mint2qif
  def self.root
    File.dirname __dir__
  end
end
