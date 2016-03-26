# Mint csv headers:
#   ["Date", "Description", "Original Description", "Amount", "Transaction Type", "Category", "Account Name", "Labels", "Notes"]
# Fix the values depending on what state your CSV data is in
# row.each { |value| value.to_s.gsub!(/^\s+|\s+$/,'') }

module Mint2qif
  class Transaction
    include Virtus.model

    attribute :date,                 Mint2qif::FieldText
    attribute :description,          Mint2qif::FieldText
    attribute :original_description, Mint2qif::FieldText
    attribute :amount,               Mint2qif::FieldText
    attribute :transaction_type,     Mint2qif::FieldText
    attribute :category,             Mint2qif::Category
    attribute :account_name,         Mint2qif::FieldText
    attribute :labels
    attribute :notes

    def to_hash
      {
        date:     date,
        amount:   signed_amount,
        status:   "c",
        payee:    description,
        memo:     original_description,
        category: category
      }
    end

    def signed_amount
      if transaction_type == "debit"
        "-#{amount}"
      else
        amount
      end
    end
  end
end