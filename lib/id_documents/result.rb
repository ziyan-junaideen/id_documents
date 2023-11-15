# frozen_string_literal: true

# The parsed result of the ID document
class IDDocuments::Result
  attr_accessor :flags, :id_number, :metadata, :valid

  def initialize(id_number)
    @id_number = id_number
    @flags = []
    @metadata = {}
  end

  def raise_errors
    raise IDDocuments::InvalidBirthDayOfYearError if flags.include? :invalid_birth_day_of_year
  end
end
