module Mint2qif
  class FieldText < Virtus::Attribute
    def coerce(value)
      value.gsub(/^\s+|\s+$/,'')
    end
  end
end