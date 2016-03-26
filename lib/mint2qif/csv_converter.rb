require 'csv'
require 'qif'

module Mint2qif
  class CsvConverter
    attr_reader :bank_input

    def initialize(file:)
      @bank_input = CSV.read(file)
      @output = {}
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
        Qif::Writer.open("#{account_name}.qif", type = 'Bank', format = 'dd/mm/yyyy') do |qif|
          transactions.each do |transaction|
            qif << Qif::Transaction.new(transaction.to_hash)
          end
        end
      end
    end
  end
end