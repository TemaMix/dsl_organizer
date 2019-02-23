require 'spec_helper'

RSpec.describe DslOrganizer::Container do
  describe '#[]=' do
    let(:container) { Class.new { include DslOrganizer::Container }.new }

    it 'adds object to container' do
      result_object = :result_object
      container[:key] = result_object

      expect(container[:key]).to eq(result_object)
    end
  end

  describe '#[]' do
    let(:container) { Class.new { include DslOrganizer::Container }.new }

    it 'returns nil from container' do
      expect(container[]).to eq(nil)
    end
  end

  describe '#real_container' do
    let(:container) { Class.new { include DslOrganizer::Container }.new }

    it 'returns an empty hash from container' do
      expect(container.real_container).to eq({})
    end
  end

  describe '#reset' do
    let(:container) { Class.new { include DslOrganizer::Container }.new }

    it 'returns an empty hash from container' do
      result_object = :result_object
      container[:key] = result_object
      container.reset
      expect(container.real_container).to eq({})
    end
  end
end
