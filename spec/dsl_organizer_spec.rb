require 'spec_helper'

RSpec.describe DslOrganizer do
  it 'has a version number' do
    expect(DslOrganizer::VERSION).not_to be nil
  end

  after :each do
    DslOrganizer::ExportContainer.reset
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
                         'Add DSL commands for work')
    end
  end
end
