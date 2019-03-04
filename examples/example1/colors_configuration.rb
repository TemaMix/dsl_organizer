# Example 1
#
# Current structure shows as the DslOrganizer can use to create a basic dsl
# in your program.
#
# After execution it in the terminal is printed follow:
#   `execute before something happen`
#   `execute some process`
#   `execute after something happen`


require 'dsl_organizer'

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

module Configuration
  include DslOrganizer.dictionary(
      commands: %i[font_colors backgrounds]
  )
end

Configuration.run do
  font_colors '#AAA'
  font_colors '#BBB'
  backgrounds '#CCC'
end

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

Configuration.print_all_colors