# rails-env

Avoid environment detection on Rails.

## Installation

Add this line to your application's Gemfile:

    gem 'rails-env'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails-env

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

Looks dumb, but you don't have to use the long `Rails.configuration` or assign it to a local variable. This is useful when you're extracting out things to initializers.

To match all environments, use `:any`.

```ruby
Rails.env.on(:any) do
  config.assets.version = '1.0'
end
```

## Upgrading from previous versions

Previous versions used to yield the configuration; this is no longer true on 1.0+.

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

## Contributing

1. Fork it ( https://github.com/fnando/rails-env/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
