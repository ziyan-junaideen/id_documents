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
      IDDocuments::LKA::IDCard::OldFormat.new(@id_number).parse
    when NEW_FORMAT
      NewFormat.new(@id_number).parse
    else
      raise IDDocuments::InvalidFormatError
    end
  end

  class OldFormat
    FORMAT = /([0-9]{2})([0-9]{3})([0-9]{3})([0-9]{1})(V|X)/i.freeze

    def initialize(id_number)
      @id_number = id_number
      @result = IDDocuments::Result.new(@id_number)
    end

    def parse
      find_dob
      find_gender
      find_voter_status

      @result.metadata[:id_format] = :old
      @result.metadata[:sequence] = metadata[:sequence]
      @result.valid = true # TODO: How to use the check digit?

      @result
    end

    def metadata
      return @metadata if @metadata

      _, year, day_of_year, sequence, check, voter_status = @id_number.upcase.match(FORMAT).to_a

      @metadata = { year: year.to_i, day_of_year: day_of_year.to_i, sequence: sequence.to_i,
                    check: check.to_i, voter_status: voter_status }
    end

    def find_dob
      day_of_year = metadata[:day_of_year]
      day_of_year -= 500 if metadata[:day_of_year] >= 500

      year = metadata[:year] + 1900
      dob = Date.new(year, 1, 1).next_day(day_of_year - 2)

      if dob.year > year
        @result.flags << :invalid_birth_day_of_year
        @result.valid = false
        @result.metadata[:dob] = nil
      else
        @result.metadata[:dob] = dob
      end
    end

    def find_gender
      @result.metadata[:gender] = metadata[:day_of_year] >= 500 ? :female : :male
    end

    def find_voter_status
      @result.metadata[:voter_status] = metadata[:voter_status] == "V" ? :voter : :non_voter
    end
  end

  class NewFormat
    FORMAT = /([0-9]{4})([0-9]{3})([0-9]{4})([0-9]{1})/i.freeze

    def initialize(id_number)
      @id_number = id_number
      @result = IDDocuments::Result.new(@id_number)
    end

    def parse
      find_dob
      find_gender

      @result.metadata[:id_format] = :new
      @result.valid = true # TODO: How to use the check digit?

      @result
    end

    def metadata
      return @metadata if @metadata

      _, year, day_of_year, sequence, check, voter_status = @id_number.upcase.match(FORMAT).to_a

      @metadata = { year: year.to_i, day_of_year: day_of_year.to_i, sequence: sequence.to_i,
                    check: check.to_i, voter_status: voter_status }
    end

    def find_dob
      day_of_year = metadata[:day_of_year]
      day_of_year -= 500 if metadata[:day_of_year] >= 500

      year = metadata[:year]
      dob = Date.new(year, 1, 1).next_day(day_of_year - 2) # TODO: Jan 1 is day 0 as it seems

      if dob.year > year
        @result.flags << :invalid_birth_day_of_year
        @result.valid = false
        @result.metadata[:dob] = nil
      else
        @result.metadata[:dob] = dob
      end
    end

    def find_gender
      @result.metadata[:gender] = metadata[:day_of_year] >= 500 ? :female : :male
    end
  end
end
