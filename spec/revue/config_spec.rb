require 'spec_helper'

module Revue
  RSpec.describe Config do
    subject { Config.new 'spec/fixtures/config.yml' }

    it 'starts with a path to the yaml' do
      expect(subject.path).to match(/fixtures/)
    end

    xit 'returns env vars in place of yaml attrs' do
      expect(subject.revue_foo).to eq(ENV['REVUE_FOO'])
    end

    it 'defaults to yaml attrs' do
      expect(subject.yaml_key).to eq('yaml_value')
    end

    it 'throws an exception when key cannot be found' do
      expect { subject.undefined_key }.to raise_error
    end
  end
end
