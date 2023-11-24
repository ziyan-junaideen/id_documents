# frozen_string_literal: true

# Parser for ID cards issued after 2015.
#
# @see IDDocuments::LKA::IDCard
# @see https://en.wikipedia.org/wiki/National_identity_card_(Sri_Lanka)
class IDDocuments::LKA::IDCardNewFormat
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

  # rubocop:disable Metrics/MethodLength Metrics/AbcSize
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
  # rubocop:enable Metrics/MethodLength Metrics/AbcSize

  def find_gender
    @result.metadata[:gender] = metadata[:day_of_year] >= 500 ? :female : :male
  end
end
