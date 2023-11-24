# frozen_string_literal: true

module IDDocuments
  class Inflector < Zeitwerk::GemInflector
    def camelize(basename, abspath)
      if basename =~ /\A[a-z]{3}\z/ && abspath =~ %r{/rules/[a-z]{3}}
        basename.upcase
      elsif basename =~ /\Aid_(.*)/
        "ID#{super(::Regexp.last_match(1), abspath)}"
      else
        super
      end
    end
  end
end
