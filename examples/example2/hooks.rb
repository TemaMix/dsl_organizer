# Example 2
#
# Current structure shows as the DslOrganizer can use to create hooks in your
# program.
#
# After execution it in the terminal is printed follow:
#   `execute before something happen`
#   `execute some process`
#   `execute after something happen`


require 'dsl_organizer'

class AfterHook
  include DslOrganizer::ExportCommand[:after]

  def call(&block)
    hooks.unshift(block)
  end

  def hooks
    @hooks ||= []
  end
end

class BeforeHook
  include DslOrganizer::ExportCommand[:before]

  def call(&block)
    hooks.push(block)
  end

  def hooks
    @hooks ||= []
  end
end

module HooksOperator
  def self.included(base)
    base.class_eval do
      extend ClassMethods
    end
  end

  module ClassMethods
    def with_hooks
      run_hooks(dsl_container[:before].hooks)
      yield
      run_hooks(dsl_container[:after].hooks)
    end

    private

    def run_hooks(hooks)
      hooks.each { |hook| instance_exec(&hook) }
    end
  end
end

module Process
  include DslOrganizer.dictionary(
      commands: %i[before after]
  )

  include HooksOperator

  def self.start
    with_hooks do
      puts 'execute some process'
    end
  end
end

Process.run do
  before { puts 'execute before something happen' }
  after  { puts 'execute after something happen' }
end

Process.start