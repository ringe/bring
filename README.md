# Bring

[![Build Status](https://travis-ci.org/wepack/bring.png)](https://travis-ci.org/wepack/bring)

A simple ruby library for communicating with the Bring's APIs (see:
[developer.bring.com](http://developer.bring.com)).

*For now only the Postal Code and Tracking API is supported.*

## Installation

Add this line to your application's Gemfile:

    gem 'bring'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bring

## Usage

From the commandline:

    $ bring postal_code 0190 no
    OSLO

    $ bring tracking TESTPACKAGE-EDI
    Shipment Number: SHIPMENTNUMBER
    Total Weight: 16.5 kg
    Total Volume: 45.2 dm3
    Number of Packages: 1

    Package Number: TESTPACKAGEEDI
    Measurements: 41x38x29 cm (LxWxH)

    Status: PRE_NOTIFIED
    Ingen sending er mottatt ennå, kun melding om dette
    2013-10-06 12:44

Or in Ruby:
```ruby
require 'bring/postal_code'
Bring::PostalCode.new('0190', country: 'no).city # => 'OSLO'
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
