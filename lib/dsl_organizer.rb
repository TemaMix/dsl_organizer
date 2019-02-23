require_relative 'dsl_organizer/errors'
require_relative 'dsl_organizer/container'
require_relative 'dsl_organizer/command_container'
require_relative 'dsl_organizer/export_container'
require_relative 'dsl_organizer/export_command'
require_relative 'dsl_organizer/version'
require_relative 'dsl_organizer/core'

# DslOrganizer allows to build flexible notations very quickly
# and same time they will understandable.
# @example:
#   include DslOrganizer.dictionary(commands: {
#       before: BeforeHook,
#       after: AfterHook
#   })
# @note:
#   The idea was found here
#   https://www.toptal.com/ruby/ruby-dsl-metaprogramming-guide
module DslOrganizer
  extend DslOrganizer::Core
end
