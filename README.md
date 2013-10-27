# Macaco

Tiny wrapper around [Mandrill's API](https://mandrillapp.com/api/docs/)

## Installation

Add this line to your application's Gemfile:

    gem 'macaco'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install macaco

## Usage

You can configure Macaco to use an API by passing a block to the
configure method. Here I've used an environment variable:

```ruby
Macaco.configure do |config|
  config.api_key = ENV['MANDRILL_API_KEY']
end
```

At the moment we just have the [send message](https://mandrillapp.com/api/docs/messages.JSON.html#method=send) method. Use it like this:

Form your data hash:

```ruby
data = {
  message: {
    text: 'Boom boom',
    html: '''
      <h1>My email title</h1>
      <p>My email body</p>
      <small>Monkey Corp Ltd</small>
    ''',
    subject: 'Test subject',
    from_email: 'james@jamesduncombe.com',
    to: [{ email: 'james@jamesduncombe.com' }]
  }
}
```

Then call the method:

```ruby
Macaco::Messages.send_message(data)
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
