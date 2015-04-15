require 'spec_helper'

module Revue
  RSpec.describe Config do
    subject { Config.new 'spec/fixtures/config.yml' }

    it 'starts with a path to the yaml' do
      expect(subject.path).to match(/fixtures/)
    end

    it 'returns env vars in place of yaml attrs' do
      expect(subject.ruby_engine).to eq(ENV['RUBY_ENGINE'])
    end

    it 'defaults to yaml attrs' do
      expect(subject.yaml_key).to eq('yaml_value')
    end

    it 'throws an exception when key cannot be found' do
      expect { subject.undefined_key }.to raise_error
    end
  end
end
