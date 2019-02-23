require 'byebug'
module DslOrganizer
  # Load methods for control dsl commands.
  module Core
    # @syntax
    #   commands: { <command>:<class executor> }
    # @example
    #   commands: { after: AfterHook, before: BeforeHook }
    # @return [Module]
    # rubocop:disable Metrics/AbcSize
    def dictionary(commands: [])
      if commands.nil? || commands.empty?
        raise Errors::DslCommandsNotFound, 'Add DSL commands for work'
      end

      commands.each do |command|
        unless ExportContainer.real_container.key?(command)
          raise Errors::DslCommandsNotFound, 'Add DSL commands for work'
        end
      end

      command_class = Class.new do
        commands.each do |command|
          define_method command do |values = [], &block|
            command_instance = ExportContainer[command].new(*values, &block)

            execute_immediately = command_instance.respond_to? :call
            CommandContainer[command] = command_instance

            command_instance.call(*values, &block) if execute_immediately
          end
        end
      end

      class_methods = Module.new do
        attr_reader :target_url

        define_method :used_dsl do
          @used_dsl ||= command_class.new
        end

        def run(&block)
          used_dsl.instance_eval(&block)
        end
      end

      Module.new do
        singleton_class.send :define_method, :included do |host_class|
          host_class.extend class_methods
        end
      end
    end
    # rubocop:enable Metrics/AbcSize
  end
end
