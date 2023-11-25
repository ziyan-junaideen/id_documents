require "id_documents"
require "thor"
require "artii"

class IDDocuments::CLI < Thor
  desc "parse ID_NUMBER", "Determins the validity of the ID number and extract metadata"
  method_option :country, aliases: "-c", type: :string, required: true
  method_option :type, aliases: "-t", type: :string, required: true
  method_option :number, aliases: "-n", type: :string, required: true
  def parse
    puts IDDocuments.parse(options[:country].to_sym, options[:type].to_sym, options[:number]).pp
  end

  desc "about", "About IDDocuments"
  def about
    artii = Artii::Base.new font: "standard"
    message = """
#{artii.asciify("IDDocuments")}
 by Ziyan Junaideen

 A variety of documents are used globally to verify a person's identity.
 Businesses could use document numbers and embedded metadata (date of birth,
 gender, etc) in supported documents as a first line of defense against fraud.

 IDDocuments intends to provide a unified interface to validate ID document
 numbers.
    """
    puts message
  end

  desc "version", "Prints version"
  def version
    puts "IDDocuments version #{IDDocuments::VERSION}"
  end

  def self.exit_on_failure?
    true
  end
end
