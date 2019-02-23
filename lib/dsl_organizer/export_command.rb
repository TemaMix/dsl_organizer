module DslOrganizer
  # It allows to define what a class is a executor (hook).
  # @note Just include this to the target class and think up a command name.
  # @example
  #   include DslOrganizer::ExportCommand[:after]
  # rubocop:disable Metrics/MethodLength
  module ExportCommand
    def self.[](command_name)
      Module.new do
        @command_name = command_name

        def self.included(base)
          if ExportContainer[@command_name].nil?
            ExportContainer[@command_name] = base
          else
            raise(
              Errors::ExecutorDidMountEarly,
              "The component for command name: `#{@command_name}`" \
              ' was mounted early. Avoid duplication naming within commands.'
            )
          end
        end
      end
    end
    # rubocop:enable Metrics/MethodLength
  end
end
