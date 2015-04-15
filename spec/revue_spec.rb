require 'spec_helper'

describe Revue do
  it 'has a version number' do
    expect(Revue::VERSION).not_to be nil
  end

  it 'instantiates a server' do
    expect(Revue.server).to be_a(Revue::Server)
  end

  it 'manages global configuration' do
    expect(Revue).to respond_to(:config)
  end
end
