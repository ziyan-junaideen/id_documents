module IDDocuments
  class Inflector < Zeitwerk::GemInflector
    def camelize(basename, abspath)
      if basename =~ /\A[a-z]{3}\z/ && abspath =~ %r{/rules/[a-z]{3}}
        basename.upcase
      else
        super
      end
    end
  end
end
