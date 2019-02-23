module DslOrganizer
  # It defines methods to operate with executors.
  module Container
    def []=(command, executor)
      real_container[command] = executor
    end

    def [](command = nil)
      real_container[command]
    end

    def real_container
      @real_container ||= {}
    end

    def reset
      @real_container = {}
    end
  end
end
