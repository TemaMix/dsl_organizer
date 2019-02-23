require 'spec_helper'

describe DslOrganizer do
  it 'has a version number' do
    expect(DslOrganizer::VERSION).not_to be nil
  end

  context 'success integration' do
    it 'is executed dsl for dummy class' do
      AfterHook = Struct.new(:status) do
        def call
          "Current status #{status}"
        end
      end

      AfterHook.include(DslOrganizer::ExportCommand[:after])

      dummy_class = Class.new do
        include DslOrganizer.dictionary(commands: [:after])
      end

      expect_any_instance_of(AfterHook)
        .to receive(:call).and_return('Current status enabled')

      dummy_class.run do
        after 'enabled'
      end
    end
  end

  context 'failure integration' do
    it 'adds to class a dsl without commands' do
      expect do
        Class.new { include DslOrganizer.dictionary }
      end.to raise_error(DslOrganizer::Core::DslCommandsNotFound,
                         'Add DSL commands for work')
    end

    it 'adds to class a dsl without commands to commands container' do
      expect do
        Class.new { include DslOrganizer.dictionary(commands: [:after]) }
      end.to raise_error(DslOrganizer::Core::DslCommandsNotFound,
                         'Add DSL commands for work')
    end
  end
end
