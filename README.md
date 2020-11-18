# rails-env

[![Tests](https://github.com/fnando/rails-env/workflows/ruby-tests/badge.svg)](https://github.com/fnando/rails-env)
[![Code Climate](https://codeclimate.com/github/fnando/rails-env/badges/gpa.svg)](https://codeclimate.com/github/fnando/rails-env)
[![Gem](https://img.shields.io/gem/v/rails-env.svg)](https://rubygems.org/gems/rails-env)
[![Gem](https://img.shields.io/gem/dt/rails-env.svg)](https://rubygems.org/gems/rails-env)

Avoid environment detection on Rails.

## Installation

```bash
gem install rails-env
```

Or add the following line to your project's Gemfile:

```ruby
gem "rails-env"
```

## Usage

Instead of checking for the current environment like this:

```ruby
if Rails.env.production?
  # Do something with Rails.configuration
end
```

You can just use:

```ruby
Rails.env.on(:production) do
  config.assets.version = '1.0'
end
```

Looks dumb, but you don't have to use the long `Rails.configuration` or assign
it to a local variable. This is useful when you're extracting out things to
initializers.

To match all environments, use `:any`.

```ruby
Rails.env.on(:any) do
  config.assets.version = '1.0'
end
```

## Gotcha

Not all options can be defined through `Rails.env`. Rails propagates options on
its engine file, meaning that every option defined on `config` afterwards must
be manually propagated.

It's hard to automatically propagate every existing option, so we have the most
common options covered, as you can see in the list below:

- action_controller
- action_mailer
- action_view
- active_job
- active_record
- time_zone
- auto/eager load paths
- i18n
- hosts

If you need to set any option not covered by rails-env,
[please open a ticket](https://github.com/fnando/rails-env/issues/new).

## Upgrading from previous versions

Previous versions used to yield the configuration; this is no longer true on
1.0+.

So, instead of using

```ruby
Rails.env.on(:development) do |config|
  config.assets.version = '1.0'
end
```

use

```ruby
Rails.env.on(:development) do
  config.assets.version = '1.0'
end
```

## Maintainer

- [Nando Vieira](https://github.com/fnando)

## Contributors

- https://github.com/fnando/rails-env/contributors

## Contributing

For more details about how to contribute, please read
https://github.com/fnando/rails-env/blob/main/CONTRIBUTING.md.

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT). A copy of the license can be
found at https://github.com/fnando/rails-env/blob/main/LICENSE.md.

## Code of Conduct

Everyone interacting in the rails-env project's codebases, issue trackers, chat
rooms and mailing lists is expected to follow the
[code of conduct](https://github.com/fnando/rails-env/blob/main/CODE_OF_CONDUCT.md).
