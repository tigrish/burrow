# Burrow

This gem builds on top of the `bunny` gem and aims to remove as much of
the boilerplate code as possible.

**This gem is what it is, do not expect amazing support here!**

## Installation

Add this line to your application's Gemfile:

    gem 'burrow'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install burrow

## Usage

Set up a server and handle incoming messages :

```ruby
server = Burrow::Server.new('my_queue')
server.subscribe do |method, params|
  if method == 'my_method'
    {foo: 'bar', baz: 'biz'}
  end
end
```

Set up a client and send messages :

```ruby
client = Burrow::Client.new('my_queue')
json   = client.publish('my_method', first_param: 'one', second_param: 'two')
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/burrow/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
