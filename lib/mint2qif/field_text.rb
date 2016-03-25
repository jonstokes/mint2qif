module Mint2qif
  class FieldText < Virtus::Attribute
    def coerce(value)
      value.strip
    end
  end
end