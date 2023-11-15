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
      OldFormat.new(@id_number).parse
    when NEW_FORMAT
      NewFormat.new(@id_number).parse
    else
      raise IDDocuments::InvalidFormatError
    end
  end

  def valid?; end

  def metadata; end

  class OldFormat
    FORMAT = /([0-9]{2})([0-9]{3})([0-9]{3})([0-9]{1})(V|X)/i.freeze

    def initialize(id_number)
      @id_number = id_number
    end

    def parse
      ctx = {}
      ctx[:result] = IDDocuments::Result.new(@id_number)

      breakdown(ctx)
      find_dob(ctx)
      find_gender(ctx)
      find_sequence(ctx)
      find_voter(ctx)

      ctx[:result]
    end

    def break_down(ctx)
      _, year, day_of_year, sequence, check, voter = @id_number.upcase.match(FORMAT).to_a
      ctx[:data] = { year: year.to_i, day_of_year: day_of_year.to_i, sequence: sequence.to_i,
                     check: check.to_i, voter: voter == "V" }
    end

    def find_dob(ctx)
      day_of_year = ctx[:data][:day_of_year] >= 500 ? ctx[:data][:day_of_year] - 500 : ctx[:data][:day_of_year]
      ctx[:result].metadata[:dob] = DateTime.new(ctx[:data][:year], 1, 1).next_day(day_of_year)
    end

    def other
      result = IDDocuments::Result.new(@id_number)

      @id_number.match(FORMAT)

      year = ::Regexp.last_match(1).to_i + 1900
      day = ::Regexp.last_match(2).to_i
      gender = day >= 500 ? :female : :male

      day -= 500 if day >= 500 # Remove the female offset

      dob = DateTime.new(year, 1, 1).next_day(day)

      if dob.year > year
        dob = nil
        result.flags << :invalid_birth_day_of_year
        result.valid = false
      end

      result.metadata = {
        dob: dob,
        gender: gender,
        sequence: ::Regexp.last_match(3).to_i,
        check: ::Regexp.last_match(4).to_i,
        voter: ::Regexp.last_match(5) == "V"
      }

      result
    end
  end

  class NewFormat
  end
end
