# Parse Stack - Async

This [Parse Stack](https://github.com/modernistik/parse-stack) plugin adds support for background saves and deletes, similar to the use of `saveInBackground` and `saveEventually` in other [Parse Server](https://github.com/ParsePlatform/parse-server) SDKs. It utilizes [SuckerPunch](https://github.com/brandonhilkert/sucker_punch) to perform the asynchronous processing of the API operation in a separate queue.

[![Gitter](https://badges.gitter.im/modernistik/parse-stack.svg)](https://gitter.im/modernistik/parse-stack?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'parse-stack-async'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install parse-stack-async

## Usage
This plugin for Parse Stack allows you to save and delete objects in an asynchronous manner, without blocking the main thread of an application. This is useful when saving objects in a web application like Rails.

This plugin adds two methods to all `Parse::Object` subclasses: `save_eventually` and `destroy_eventually`, which mimic the same API in the mobile SDKs for Parse. These take an optional block that will provide you information whether it was successful in performing the corresponding operation.

```ruby

require 'parse/stack'
require 'parse/stack/async'

object = Parse::User.first # get a user
object.username = 'newUserName'

# saves object in a background thread.
object.save_eventually do |success|
  puts "Successfully saved in Parse!" if success
end

# Or delete asynchronously
anotherObject.destroy_eventually do |success|
  puts "Deleted object from Parse!" if success
end

```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/modernistik/parse-stack-async.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
