require 'dsl_organizer'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.order = :random

  # Print the n slowest examples and example groups at the
  # end of the spec run, to help surface which specs are running
  # particularly slow.
  config.profile_examples = 3

  config.around(:example, remove_const: true) do |example|
    const_before = Object.constants

    # DslOrganizer::ExportContainer.remove_class_variable(:@@real_container)
    # DslOrganizer::CommandContainer.remove_class_variable(:@@real_container)

    example.run

    const_after = Object.constants
    (const_after - const_before).each do |const|
      Object.send(:remove_const, const)
    end
  end
end
