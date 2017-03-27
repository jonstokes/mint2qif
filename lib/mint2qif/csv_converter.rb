require 'csv'
require 'qif'

module Mint2qif
  class CsvConverter
    attr_reader :output, :bank_input, :output_directory

    def initialize(args={})
      @output = {}
      @bank_input = args.fetch(:bank_input, Mint2qif.configuration.bank_input)
      @output_directory = args.fetch(:output_directory, Mint2qif.configuration.output_directory)
    end

    def split_accounts
      bank_input.each_with_index do |line, index|
        begin
          transaction = Mint2qif::Transaction.new(line)
          @output[transaction.account_name] ||= []
          @output[transaction.account_name] << transaction
        rescue Exception => e
          puts "ERROR, Line #{index + 2}: #{line}"
          puts "   message: #{e.message}"
        end
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