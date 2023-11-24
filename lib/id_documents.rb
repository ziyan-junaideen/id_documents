# frozen_string_literal: true

require "date"
require "zeitwerk"
require_relative "id_documents/inflector"

loader = Zeitwerk::Loader.for_gem
loader.inflector = IDDocuments::Inflector.new(__FILE__)
loader.collapse("#{__dir__}/id_documents/rules")
loader.collapse("#{__dir__}/id_documents/errors")
loader.setup
