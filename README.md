# Obstinately

A small command-line utility to retry shell invocations with exponential backoff.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'obstinately'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install obstinately

## Usage

```shell
obstinately ping -c 1 google.com
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/rake` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bin/rake install`. To release a new version, update the version number in `VERSION`, and then run `bin/rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/segiddins/obstinately. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Obstinately project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/segiddins/obstinately/blob/master/CODE_OF_CONDUCT.md).
