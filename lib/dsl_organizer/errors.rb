module DslOrganizer
  module Errors
    class DslCommandsNotFound < StandardError; end
    class ExecutorDidMountEarly < StandardError; end
    class MethodCallNotFound < StandardError; end
  end
end
