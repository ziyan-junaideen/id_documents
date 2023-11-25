# IDDocuments

IDDocuments is a Ruby gem that can help validate the correctness of ID documents. Use it to validate the pattern of the
document number. When applicable you will also have access to metadata embedded in the document number (ex: LKA NIC
includes date of birth, gender, and a checksum to validate integrity of the number).

This library is not a replacement for a proper KYC solution similar to Veriff. Use it more like a form validation or
applicable as a meta data extractor. The original intent of this library is to check a users age against the NIC
number.

> This project is WIP and not ready for production use.

## Installation

To use the gem outside a Ruby project, install the gem:

```rb
gem install id_documents
```

To use the gem in a Ruby project, add the following to the Gemfile:

```rb
gem 'id_documents'
```

## Usage

The GEM provides an command line interface and a Ruby API.

```sh
id_documents --country LKA --metadata 197419202757
```

```rb
require 'id_documents'

result = IDDocuments.parse(:LKA, :national_id, "197419202757")

result.valid? # true
result.metadata['dob'] # 1974-07-10
result.metadata['gender'] # :male
```

## Document Coverage

Development of this GEM will be done in stages. Current planned trajectory:

- Stage 1: Sri Lanka (completed by first release)
- Stage 2: South Asia
- Stage 3: South East Asia
- Stage 4: Europe
- Stage 5: North America
- Stage 6: South America
- Stage 7: Africa

How ever, if you are interested in implementing a parser for your country, feel
free to open a PR. This is merely my personal roadmap for a hobby project.

If you are not a developer, hit me on Twitter and I will
see if I can find some time to research about ID documents in your country and
implement the parser.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/id_documents. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/id_documents/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the IDDocuments project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/id_documents/blob/master/CODE_OF_CONDUCT.md).
