require 'spec_helper'

describe Mint2qif::Transaction do
  before do
    Mint2qif.configure do |config|
      config.custom_categories_file = "spec/fixtures/custom_categories.yml"
    end
  end

  context "translation" do
    let(:line) {{
      date: "09/10/2015",
      description: "test transaction ",
      original_description: "TEST TRANSACTION 123456789",
      amount: "100.00",
      transaction_type: "debit",
      category: "Tolls",
      account_name: "Chase Checking ",
      labels: "A",
      notes: "b"
    }}

    let(:transaction) { Mint2qif::Transaction.new(line) }

    it "translates a Mint CSV line" do
      expect(transaction.to_hash).to eq(
        date: "09/10/2015",
        amount: "-100.0",
        status: "c",
        payee: "test transaction",
        memo: "TEST TRANSACTION 123456789",
        category: "Auto & Transport:Tolls"
      )
    end
  end
end
