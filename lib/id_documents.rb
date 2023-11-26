# frozen_string_literal: true

require "date"
require "zeitwerk"
require_relative "id_documents/inflector"

loader = Zeitwerk::Loader.for_gem
loader.inflector = IDDocuments::Inflector.new(__FILE__)
loader.inflector.inflect("cli" => "CLI")
loader.collapse("#{__dir__}/id_documents/rules")
loader.collapse("#{__dir__}/id_documents/errors")
loader.setup

module IDDocuments
  # The current version of the GEM.
  # @return [String] the version of the gem (ie: x.y.z)
  def self.version; end

  # Parse an ID document number.
  # @param country [Symbol] the country code (ie: LKA for Sri Lanka)
  # @param type [Symbol] the type of document (ie: :national_id)
  # @param document_number [String] the document id to parse
  # @return [IDDocuments::Result] the parsed result of the ID document
  def self.parse(country, type, document_number)
    klass = PARSERS.dig(country, type)
    raise DocumentNotSupportedError unless klass

    klass.new(document_number).parse
  end

  # Registered list of parsers.
  # @return [Hash] the list of parsers
  # TODO: Should we insted build the class name based on the country and type?
  PARSERS = {
    LKA: {
      national_id: LKA::IDCard,
      passport: LKA::Passport
    }
  }.freeze
end
