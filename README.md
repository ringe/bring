# Bring

A simple ruby library for communicating with the Bring's APIs (see:
[developer.bring.com](http://developer.bring.com)).

*For now only the Postal Code API is supported.*

## Installation

Add this line to your application's Gemfile:

    gem 'bring'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bring

## Usage

From the commandline:
```
$ bring postal_code 0190 no
OSLO
```

Or in Ruby
```
require 'bring/postal_code'
Bring::PostalCode.new('0190', country: 'no).city # => 'OSLO'
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
