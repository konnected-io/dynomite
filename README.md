# DynamodbModel

A simple wrapper library to make DynamoDB usage a little more friendly.  The modeling is ActiveRecord-ish but not exactly because DynamoDB is a different type of database.  Examples and the [item_spec.rb](spec/lib/dynamodb_model/item_spec.rb) explain it best:

## Examples

First define a class:

```ruby
class Post < DynamodbModel::Item
  # partition_key "id" # optional, defaults to id
end
```

### Create

```ruby
post = Post.new
post = post.replace(title: "test title")
post.attrs # {"id" => "generated-id", title" => "my title"}
```

`post.attrs[:id]` now contain a generated unique partition_key id.  Usually the partition_key is 'id'. You can set your own unique id also by specifying id.

```ruby
post = Post.new(id: "myid", title: "my title")
post.replace
post.attrs # {"id" => "myid", title" => "my title"}
```

Note that the replace method replaces the entire item, so you need to merge the attributes if you want to keep the other attributes.  Know this is weird, but this is how DynamoDB works.

### Find

```ruby
post = Post.find("myid")
post.attrs = post.attrs.deep_merge("desc": "my desc") # keeps title field
post.replace
post.attrs # {"id" => "myid", title" => "my title", desc: "my desc"}
```

The convenience `attrs` method performs a deep_merge:

```ruby
post = Post.find("myid")
post.attrs("desc": "my desc 2") # <= does a deep_merge
post.replace
post.attrs # {"id" => "myid", title" => "my title", desc: "my desc 2"}
```

Note, a race condition edge case can exist when several concurrent replace
calls are happening.  This is why the interface is called replace to
emphasis that possibility.

### Delete

```ruby
resp = Post.delete("myid")  # dynamodb client resp
# or
post = Post.find("myid")
resp = post.delete  # dynamodb client resp
```

### Scan

```ruby
options = {}
posts = Post.scan(options)
posts # Array of Post items.  [Post.new, Post.new, ...]
```

## Migration Support

DynamodbModel supports ActiveRecord-like migrations.  Examples are in: [docs](docs).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dynamodb_model'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dynamodb_model

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tongueroo/dynamodb_model.

TODO

* implement Post.query
* implement `post.update` with `db.update_item` in a Ruby-ish way
