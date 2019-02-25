module DslOrganizer
  # Load methods for control dsl commands.
  module Core
    # @syntax
    #   commands: { <command>:<class executor> }
    # @example
    #   commands: { after: AfterHook, before: BeforeHook }
    # @return [Module]
    def dictionary(commands: [])
      @dsl_commands = commands
      validate_commands

      dsl_operator = new_dsl_operator
      dsl_module = new_dsl_module(dsl_operator: dsl_operator)
      Module.new do
        singleton_class.send :define_method, :included do |host_class|
          host_class.extend dsl_module
        end
      end
    end

    private

    attr_reader :dsl_commands

    def validate_commands
      if dsl_commands.nil? || dsl_commands.empty?
        raise Errors::DslCommandsNotFound, 'Add DSL commands for work'
      end

      dsl_commands.each do |command|
        unless ExportContainer.real_container.key?(command)
          raise(Errors::DslCommandsNotFound,
                "Add an executor for the `#{command}` command for work")
        end
      end
    end

    def new_dsl_module(dsl_operator:)
      commands = dsl_commands
      Module.new do
        define_method :used_dsl do
          @used_dsl ||= dsl_operator.new
        end

        define_method :dsl_commands do
          @dsl_commands ||= commands
        end

        def run(&block)
          used_dsl.instance_eval(&block)
        end
      end
    end

    def new_dsl_operator
      commands = dsl_commands
      Class.new do
        commands.each do |command|
          define_method command do |values = [], &block|
            unless ExportContainer[command].method_defined? :call
              raise(
                Errors::MethodCallNotFound,
                'Not found `call` method for the' \
                " `#{ExportContainer[command].name}` class and" \
                " the `#{command}` command"
              )
            end

            command_instance = CommandContainer[command] ||
                               ExportContainer[command].new

            unless CommandContainer[command]
              CommandContainer[command] = command_instance
            end

            command_instance.call(*values, &block)
          end
        end
      end
    end
  end
end
