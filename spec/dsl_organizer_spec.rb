require 'spec_helper'
require 'byebug'
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

  describe '#dsl_container' do
    it 'returns available dsl command container' do
      AfterHook = Class.new do
        include DslOrganizer::ExportCommand[:after]

        def call(status)
          "Current status #{status}"
        end
      end

      dummy_class = Class.new do
        include DslOrganizer.dictionary(commands: [:after])
      end

      dummy_class.run do
        after('enabled')
      end

      expect(dummy_class.dsl_container[:after].class.name).to eq('AfterHook')

      Object.send(:remove_const, :AfterHook)
    end
  end

  context 'success integration' do
    it 'is executed dsl for dummy class' do
      AfterHook = Class.new do
        attr_reader :status

        def call(status)
          @status = "Current status #{status}"
        end
      end

      AfterHook.include(DslOrganizer::ExportCommand[:after])

      dummy_class = Class.new do
        include DslOrganizer.dictionary(commands: [:after])
      end

      dummy_class.run do
        after 'enabled'
      end

      expect(
        dummy_class.dsl_container[:after].status
      ).to eq('Current status enabled')
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
