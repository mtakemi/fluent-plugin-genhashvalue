# Fluent::Plugin::GenHashValue

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/fluent/plugin/genhashvalue`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fluent-plugin-genhashvalue'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-genhashvalue


## Configuration

Example:

    <filter foo.**>
      type genhashvalue

      keys type,descr
      hash_type md5
      base64_enc true
      set_key _hash
      separator _
      inc_time_as_key true
      inc_tag_as_key false
    </filter>


Input:

    root@112133c12ee3:~/fluentd# echo '{"type":"log","descr":"description..."}' | ./bin/fluent-cat foo.test
    root@112133c12ee3:~/fluentd# echo '{"type":"log","descr":"description..."}' | ./bin/fluent-cat foo.test
    root@112133c12ee3:~/fluentd# echo '{"type":"log","descr":"description..."}' | ./bin/fluent-cat foo.test

Filterd:

    2016-10-23 15:06:05 +0000 foo.test: {"type":"log","descr":"description...","_hash":"/B3pc4NBk6Z9Ph89k+ZL4Q=="}
    2016-10-23 15:06:22 +0000 foo.test: {"type":"log","descr":"description...","_hash":"IgB25wc3M0QJfk0KteYygQ=="}
    2016-10-23 15:06:37 +0000 foo.test: {"type":"log","descr":"description...","_hash":"vvDF6eWyX5Sc01AVw8P6Cw=="}


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/fluent-plugin-genhashvalue. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

