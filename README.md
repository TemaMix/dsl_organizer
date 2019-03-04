# DslOrganizer

DslOrganizer provides a simple way to create self dsl and allows to integrate dsl to logic easy.

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
module Configuration
 include DslOrganizer.dictionary(
   commands: [:font_colors, :backgrounds]
  )
end
```
2. Secondly, you should define executors for your commands and export them.
```ruby
class FontColorExecutor
  include DslOrganizer::ExportCommand[:font_colors]
  
  def call(font_color)
     colors << font_color
  end
  
  def colors
     @colors ||= []
  end
end

class BackroundExecutor
  include DslOrganizer::ExportCommand[:backgrounds]
  
  def call(backround_color)
     colors << backround_color
  end
  
  def colors
     @colors ||= []
  end
end
```
3. Thirdly, described logic with using dsl commands can look something like that: 
 ```ruby
Configuration.run do
  font_colors'#AAA'
  font_colors '#BBB'
  backgrounds '#CCC'
end
 ```
 The dsl commands `color` and `background` will executed immediately.

4. Finally, you can integrate commands to basic logic to use for it the Dependency Injection pattern:
 ```ruby
module Configuration
  def self.print_all_colors
    dsl_container[:font_colors].colors.map do |color|
      puts color
    end
    
    dsl_container[:backgrounds].colors.map do |color|
      puts color
    end
  end
end
 ```
 
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/temamix/dsl_organizer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
