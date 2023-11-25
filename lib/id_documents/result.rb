# frozen_string_literal: true

# The parsed result of the ID document
class IDDocuments::Result
  attr_accessor :flags, :id_number, :metadata, :valid
  alias valid? valid

  def initialize(id_number)
    @id_number = id_number
    @flags = []
    @metadata = {}
  end

  def raise_errors
    raise IDDocuments::InvalidBirthDayOfYearError if flags.include? :invalid_birth_day_of_year
  end

  def pp
    [].tap do |lines|
      lines << "ID Number: #{id_number}"
      lines << "Valid: #{valid?}"
      lines << "Metadata:"
      @metadata.each { |key, value| lines << "  - #{key}: #{value}" }
      lines << "Flags: #{flags.empty? ? "None" : ""}"
      @flags.each { |flag| lines << "  - #{flag}" }
    end.join("\n")
  end
end
