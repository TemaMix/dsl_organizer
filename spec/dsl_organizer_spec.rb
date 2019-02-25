require 'spec_helper'

RSpec.describe DslOrganizer do
  it 'has a version number' do
    expect(DslOrganizer::VERSION).not_to be nil
  end

  after :each do
    DslOrganizer::ExportContainer.reset
  end

  describe '#dsl_commands' do
    it 'returns all available dsl commands' do
      AfterHook = Class.new do
        include DslOrganizer::ExportCommand[:after]

        def call(status)
          "Current status #{status}"
        end
      end

      dummy_class = Class.new do
        include DslOrganizer.dictionary(commands: [:after])
      end

      expect(dummy_class.dsl_commands).to eq([:after])

      Object.send(:remove_const, :AfterHook)
    end
  end

  context 'success integration' do
    it 'is executed dsl for dummy class' do
      AfterHook = Class.new do
        def call(status)
          "Current status #{status}"
        end
      end

      AfterHook.include(DslOrganizer::ExportCommand[:after])

      dummy_class = Class.new do
        include DslOrganizer.dictionary(commands: [:after])
      end

      expect_any_instance_of(AfterHook).to receive(:call)

      dummy_class.run do
        after 'enabled'
      end

      Object.send(:remove_const, :AfterHook)
    end
  end

  context 'failure integration' do
    it 'adds to class a dsl without commands' do
      expect do
        Class.new { include DslOrganizer.dictionary }
      end.to raise_error(DslOrganizer::Errors::DslCommandsNotFound,
                         'Add DSL commands for work')
    end

    it 'adds to class a dsl without commands to commands container' do
      expect do
        Class.new { include DslOrganizer.dictionary(commands: [:after]) }
      end.to raise_error(DslOrganizer::Errors::DslCommandsNotFound,
                         'Add an executor for the `after` command for work')
    end

    it 'adds to class a dsl without a `call` method' do
      AfterHook = Class.new

      AfterHook.include(DslOrganizer::ExportCommand[:after])
      dummy_class = Class.new do
        include DslOrganizer.dictionary(commands: [:after])
      end

      expect do
        dummy_class.run do
          after 'enabled'
        end
      end.to raise_error(
        DslOrganizer::Errors::MethodCallNotFound,
        'Not found `call` method for the `AfterHook`' \
        ' class and the `after` command'
      )
      Object.send(:remove_const, :AfterHook)
    end
  end
end
