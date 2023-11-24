# frozen_string_literal: true

# Sri Lankan ID card number parser and validator. There are two formats. The old format is 10 chars in length and was
# used until 2015. The new format is 12 chars in length.
#
# @see https://en.wikipedia.org/wiki/National_identity_card_(Sri_Lanka)
class IDDocuments::LKA::IDCard
  OLD_FORMAT = /[0-9]{9}[VX]/.freeze
  NEW_FORMAT = /[0-9]{12}/.freeze

  def initialize(id_number)
    @id_number = id_number
  end

  # @return [IDDocuments::Result] the parsed result of the ID document
  # @raise [IDDocuments::InvalidFormatError] if the ID number is not in a valid format
  def parse
    case @id_number
    when OLD_FORMAT
      IDDocuments::LKA::IDCardOldFormat.new(@id_number).parse
    when NEW_FORMAT
      IDDocuments::LKA::IDCardNewFormat.new(@id_number).parse
    else
      raise IDDocuments::InvalidFormatError
    end
  end
end
