module DslOrganizer
  # It allows to define what a class is a executor (hook).
  # @note Just include this to the target class and think up a command name.
  # @example
  #   include DslOrganizer::ExportCommand[:after]
  module ExportCommand
    def self.[](command_name)
      Module.new do
        @command_name = command_name

        def self.included(base)
          ExportContainer[@command_name] = base
        end
      end
    end
  end
end
