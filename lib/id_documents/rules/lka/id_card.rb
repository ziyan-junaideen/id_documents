# frozen_string_literal: true

class IDDocuments::LKA::IDCard
  OLD_FORMAT = /[0-9]{9}[VX]/.freeze
  NEW_FORMAT = /[0-9]{12}/.freeze

  def initialize(id_number)
    @id_number = id_number
  end

  def parse
    case id_number
    when OLD_FORMAT
      @parser = OldFormat.new(id_number)
      @metadata = @parser.metadata
    when NEW_FORMAT
      @parser = NewFormat.new(id_number)
      @metadata = @parser.metadata
    else
      raise "Invalid ID number format"
    end
  end

  def valid?; end

  def metadata; end

  class OldFormat
    def initialize(id_number)
      @id_number = id_number
    end

    def parse; end
  end

  class NewFormat
  end
end
