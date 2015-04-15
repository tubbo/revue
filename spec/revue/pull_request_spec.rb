require 'spec_helper'

module Revue
  RSpec.describe PullRequest do
    subject do
      PullRequest.new id: 666, base: pr
    end

    let :repo do
      double 'Stash::Repository'
    end

    let :issue do
      double 'Stash::JIRA::Issue'
    end

    let :ticket do
      double 'Ticket', update_attributes: true
    end

    let :pr do
      double 'Stash::PullRequest', attributes: { reviewer: 'lead' }, issues: [issue]
    end

    it 'collects all pull requests for this project' do
      allow(repo).to receive(:pull_requests).and_return [pr]
      allow(PullRequest.stash).to receive(:repositories).and_return [repo]
      expect(PullRequest.collection).to_not be_empty
      expect(PullRequest.collection.first).to be_a(PullRequest)
    end

    it 'obtains a stash client' do
      expect(PullRequest.stash).to be_a(Stash::Client)
    end

    context '#save' do
      it 'updates all tickets on the pull request when valid' do
        allow(subject).to receive(:reviewer).and_return 'lead'
        allow(Ticket).to receive(:find).and_return ticket
        expect(subject).to be_valid
        expect(subject.save).to eq(true)
      end

      it 'retuns false when not valid' do
        allow(subject).to receive(:reviewer).and_return nil
        expect(subject).to_not be_valid
        expect(subject.save).to eq(false)
      end
    end

    context '#persisted?' do
      it 'returns true when the PR can be found on Stash' do
        expect(subject).to be_persisted
      end

      it 'returns false when the PR cannot be found' do
        allow(subject).to receive(:base).and_return nil
        expect(subject).to_not be_persisted
      end
    end

    context '#tickets' do
      it 'returns all tickets tagged on the commits for this repo' do
      end
    end

    context 'reviewer' do
      it 'returns the reviewing user assigned to the pull request' do
      end
    end
  end
end
