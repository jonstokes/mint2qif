require 'csv'
require 'qif'

module Mint2qif
  class CsvConverter
    attr_reader :bank_input, :output, :output_directory, :categories_file

    def initialize(input_file:, output_directory:, categories_file:)
      @bank_input = CSV.read(
        input_file,
        headers: true,
        converters: :all,
        header_converters: lambda { |h| h.downcase.gsub(' ', '_') }
      )
      @output_directory = output_directory
      @output = {}
      @categories_file = categories_file
    end

    def split_accounts
      bank_input.each do |line|
        transaction = Mint2qif::Transaction.new(line)
        @output[transaction.account_name] ||= []
        @output[transaction.account_name] << transaction
      end
    end

    def write_files
      output.each do |account_name, transactions|
        Qif::Writer.open(File.join(output_directory, "#{account_name}.qif"), type = 'Bank', format = 'mm/dd/yyyy') do |qif|
          transactions.each do |transaction|
            qif << Qif::Transaction.new(transaction.to_hash)
          end
        end
      end
    end
  end
end