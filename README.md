# SortIndex
Proof of concept to maintain a file with sorted and unique values.
This could be helpful for building building indexes.

`Range#bsearch` is used to determine if a line is already in the file and
to determine where a line should be inserted. This means Ruby 2.0 is required.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sort_index'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sort_index

## Usage

Use `sorted_puts` on the File instance instead of `write`, `<<`, etc.

```ruby
SortIndex::File.open('animals', 'w+') do |f|
  f.sorted_puts 'cat'  # add stuff out of order
  f.sorted_puts 'bat'
  f.sorted_puts 'dog'
  f.sorted_puts 'ant'
  f.sorted_puts 'cat'  # duplicate on purpose
end

IO.read('animals')
=> "ant\nbat\ncat\ndog\n"
```

## Gotchas
Performance of writes is probably the biggest problem. There really isn't a
great way to insert lines in the middle of a file. So we do it the naive way.

1. save current position `IO#tell`
2. read the remaining bytes of the file using `IO#read`
3. write the line at the current position
4. write the rest of the contents from step 2.

Common sense would say don't create gigabyte files this way. Use unix calls
instead:

```sh
echo 'cat' >> animals
echo 'bat' >> animals
echo 'dog' >> animals
echo 'ant' >> animals
sort -u animals
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ddrscott/sort_index.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

