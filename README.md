# DslOrganizer

DslOrganizer provides a simple way to create self dsl and allows to integrate dsl to logic.

## Installation

Installation is pretty standard:

```
$ gem install dsl_organizer
```

If you use bundler to add it to your Gemfile:
```
gem 'dsl_organizer', '~> 1.0'
```

And then execute:

    $ bundle


## Usage
### Brief Example
1. Firstly, you should think up commands for your dsl.
```ruby
class Configuration
 include DslOrganizer.dictionary(
   commands: [:font_color, :background]
  )
end
```
2. Secondly, you should define executors for your commands and export them.
```ruby
class FontColorExecutor
  include DslOrganizer::ExportCommand[:color]
  
  def call(font_color)
    puts font_color
  end
end

class BackroundExecutor
  include DslOrganizer::ExportCommand[:background]
  
  def call(backround_color)
    puts backround_color
  end
end
```
3. Finally, you can use commands something like that:
 ```ruby
Configuration.run do 
  color '#AAA'
  background '#CCC'
end
 ```
 The dsl commands `color` and `background` will executed immediately.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/temamix/dsl_organizer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
