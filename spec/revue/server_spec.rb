require 'spec_helper'

module Revue
  RSpec.describe Server do
    subject { Server.new '/dev/null' }
    let :base do
      double 'Stash::PullRequest', \
        tickets: [],
        attributes: { name: 'hello' }
    end

    let :pull_request do
      PullRequest.new id: 1, base: base
    end

    before do
      allow(PullRequest).to receive(:each).and_return [pull_request]
    end

    it 'loops through open tickets' do
      expect { subject.send(:sync) }.to_not raise_error
    end
  end
end
