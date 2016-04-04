# Macaco
[![Build Status](https://travis-ci.org/jamesduncombe/macaco.svg?branch=master)](https://travis-ci.org/jamesduncombe/macaco)

Tiny wrapper around [Sendgrid](https://sendgrid.com/docs/API_Reference/Web_API/mail.html#-send) and [Mandrill API's send methods](https://mandrillapp.com/api/docs/messages.JSON.html#method=send).

## Installation

Add this line to your application's Gemfile:

    gem 'macaco'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install macaco

## Usage

You can configure Macaco to use your API key by passing a block to the
configure method. Here I've used one for Sendgrid:

```ruby
Macaco.configure do |config|
  config.api_key = ENV['SENDGRID_API_KEY']
end
```

First create a new mail object:

```ruby
mail = Macaco::Sendgrid.new do
  to [{ email: 'to@test.com', name: 'Persons Name'}, 'person@email.com']
  from 'from@test.com'
  subject 'This is my subject'
  body_html '<h1>This is a title</h1>'
  body_text 'This is my text version'
end
```

> In this case we're using Sendgrid - `Macaco::Sendgrid`. You can also use `Macaco::Mandrill` for Mandrill

Then call the send method:

```ruby
mail.send
```

#### To and From names

As you can see in the example above, you can either use a simple email address or provide a `name` attribute in order to pass this information along to the mailer service.


#### Additional methods

Each `Macaco::Sender` also has a `.to_curl` method. This allows you to get a runnable curl command from a particular `Macaco::Sender` instance. For example, running `.to_curl` on the above example gives:

```ruby
mail.to_curl
# => "curl -X POST https://api.sendgrid.com/api/mail.send.json -H 'Content-Type: application/x-www-form-urlencoded' -H 'Authorization: Bearer YOUR_TOKEN' -d 'from=from%40test.com&fromname&to=to%40test.com&to=person%40email.com&toname=Persons+Name&toname=+&subject=This+is+my+subject&html=%3Ch1%3EThis+is+a+title%3C%2Fh1%3E&text=This+is+my+text+version'"
```

## Todo

- Add further reflection methods to be able to inspect the mail object
- Add support for other API's send methods

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