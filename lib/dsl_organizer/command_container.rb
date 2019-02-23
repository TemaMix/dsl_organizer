module DslOrganizer
  # Consist of instance objects of executors (hooks)
  # @note it allows integrating executors flexibly
  #       to general logic of your application.
  class CommandContainer
    extend Container
  end
end
