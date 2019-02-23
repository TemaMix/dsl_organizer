require 'spec_helper'

RSpec.describe DslOrganizer::ExportCommand do
  describe '#[]', remove_const: true do
    after :each do
      DslOrganizer::ExportContainer.reset
    end

    it 'adds new command and executor to ExportContiner' do
      executor = Class.new { include DslOrganizer::ExportCommand[:after] }

      expect(DslOrganizer::ExportContainer[:after]).to eq(executor)
    end

    it 'raises error if a command with same name was defined early' do
      Class.new { include DslOrganizer::ExportCommand[:after] }
      expect do
        Class.new { include DslOrganizer::ExportCommand[:after] }
      end.to raise_error(
        DslOrganizer::Errors::ExecutorDidMountEarly,
        'The component for command name: `after`' \
                ' was mounted early. Avoid duplication naming within commands.'
      )
    end
  end
end
