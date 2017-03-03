# TodoistQuerynaut

Todoist Querynaut is a Ruby Gem that reimplements the [filter query language](https://support.todoist.com/hc/en-us/articles/205248842-Filters)
of Todoist.

[Todoist](https://todoist.com) has a powerful feature named filters,
yet they are implemented on client side (i.e. within their web application).
It even has a REST API that allows to do searches, yet they are not as powerful,
e.g. they don't allow for boolean operator logic.

This is where Todoist Querynaut kicks in, it has a parser for the query
language and does one or more calls to the REST API to collect the correct set
of result items.

Querynaut isn't yet fully fledged, some search capabilities are missing

* search for items within sub-projects
* filtering based on exact due dates
* filtering based on creation date
* "no labels" query

## Installation

Add this line to your application's Gemfile

```ruby
gem 'todoist_querynaut'
```

And then execute:

    $ bundle install

## Usage

```ruby
querynaut = TodoistQuerynaut::Client.new(Todoist::Client.new("your_api_token"))
result = @client.run("(overdue | today) & #work")
```

## Contributing

1. Fork it ( https://github.com/stesie/todoist_querynaut/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
