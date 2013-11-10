# Macaco
[![Build Status](https://travis-ci.org/jamesduncombe/macaco.png?branch=master)](https://travis-ci.org/jamesduncombe/macaco)

Tiny wrapper around (for now) [Mandrill API's send method](https://mandrillapp.com/api/docs/messages.JSON.html#method=send). Later to be expanded to handle Sendgrid's send method too.

## Installation

Add this line to your application's Gemfile:

    gem 'macaco'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install macaco

## Usage

By default Macaco tries to find your mail API key with the `MACACO_API_KEY`
environment variable.

However, you can configure Macaco to use a different key by passing a block to the
configure method. Here I've used a different environment variable:

```ruby
Macaco.configure do |config|
  config.api_key = ENV['MANDRILL_API_KEY']
end
```

At the moment we just have the [send message](https://mandrillapp.com/api/docs/messages.JSON.html#method=send) method. Use it like this:

First create a new mail object:

```ruby
mail = Macaco::Mandrill.new do
  to 'to@test.com'
  from 'from@test.com'
  subject 'This is my subject'
  body_html '<h1>This is a title</h1>'
  body_text 'This is my text version'
end
```

Then call the method:

```ruby
mail.send
```

## Todo

- Add further reflection methods to be able to inspect the mail object
- Add support for Sendgrid's send method


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

The MIT License (MIT)

Copyright (c) 2013 James Duncombe

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.