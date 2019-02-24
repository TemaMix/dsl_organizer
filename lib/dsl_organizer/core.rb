module DslOrganizer
  # Load methods for control dsl commands.
  module Core
    # @syntax
    #   commands: { <command>:<class executor> }
    # @example
    #   commands: { after: AfterHook, before: BeforeHook }
    # @return [Module]
    def dictionary(commands: [])
      validate_commands(commands: commands)

      dsl_operator = new_dsl_operator(commands: commands)
      dsl_module = new_dsl_module(dsl_operator: dsl_operator)
      Module.new do
        singleton_class.send :define_method, :included do |host_class|
          host_class.extend dsl_module
        end
      end
    end

    private

    def validate_commands(commands:)
      if commands.nil? || commands.empty?
        raise Errors::DslCommandsNotFound, 'Add DSL commands for work'
      end

      commands.each do |command|
        unless ExportContainer.real_container.key?(command)
          raise Errors::DslCommandsNotFound, 'Add DSL commands for work'
        end
      end
    end

    def new_dsl_module(dsl_operator:)
      Module.new do
        define_method :used_dsl do
          @used_dsl ||= dsl_operator.new
        end

        def run(&block)
          used_dsl.instance_eval(&block)
        end
      end
    end

    def new_dsl_operator(commands:)
      Class.new do
        commands.each do |command|
          define_method command do |values = [], &block|
            execute_immediately = ExportContainer[command].method_defined? :call

            command_instance = if execute_immediately
                                 CommandContainer[command] ||
                                   ExportContainer[command].new
                               else
                                 ExportContainer[command].new(*values, &block)
                               end

            unless CommandContainer[command]
              CommandContainer[command] = command_instance
            end

            command_instance.call(*values, &block) if execute_immediately
          end
        end
      end
    end
  end
end
