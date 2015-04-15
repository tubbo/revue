require 'spec_helper'

module Revue
  RSpec.describe Model do
    class MockModel < Model
      attr_accessor :name

      def persisted?
        true
      end

      def save
        true
      end
    end

    context 'when querying' do
      subject { MockModel.new }

      it 'can find itself' do
        allow(MockModel).to receive(:new).with(id: 1).and_return subject
        expect(MockModel.find(1)).to eq(subject)
      end

      it 'returns nil when not found' do
        allow(subject).to receive(:persisted?).and_return false
        allow(MockModel).to receive(:new).with(id: 1).and_return subject
        expect(MockModel.find(1)).to be_nil
      end

      it 'enumerates over collections' do
        allow(MockModel).to receive(:collection).and_return [subject]
        expect(MockModel).to respond_to(:each)
        expect(MockModel.first).to eq(subject)
      end
    end

    context 'when all methods are implemented' do
      subject { MockModel.new id: 1 }

      it 'can create itself' do
        mock_model = MockModel.create(name: 'hello')

        expect(mock_model).to be_a(MockModel)
        expect(mock_model.name).to eq('hello')
      end


      it 'updates attributes' do
        expect(subject.update_attributes(id: 123)).to eq(true)
        expect(subject.id).to eq(123)
      end

      it 'reloads with attributes' do
        expect { subject.reload! }.to_not raise_error
      end
    end

    context 'when methods are not implemented' do
      subject { Model.new id: 1 }

      it 'raises an error when save not defined' do
        expect { subject.save }.to raise_error
      end

      it 'raises an error when persisted not defined' do
        expect { subject.persisted? }.to raise_error
      end

      it 'fails to create' do
        expect { Model.create(id: 2) }.to raise_error
      end

      it 'fails to find' do
        expect { Model.find(2) }.to raise_error
      end
    end
  end
end
