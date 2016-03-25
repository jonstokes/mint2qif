module Mint2qif
  class MemoText < Virtus::Attribute
    def coerce(value)
      value.gsub!(/^\s+|\s+$/,'')
      value.strip
    end
  end
end