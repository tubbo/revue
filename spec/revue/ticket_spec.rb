require 'spec_helper'

module Revue
  RSpec.describe Ticket do
    subject do
      Ticket.new(
        id: 1,
        assignee: 'dev'
      )
    end

    let :issue do
      double 'JIRA::Issue', id: '1234'
    end

    let :project do
      double 'JIRA::Project', id: 'TESTPROJECT', issues: [issue]
    end

    before do
      allow(project).to receive(:find).and_return project
      allow(Ticket.jira).to receive(:Project).and_return project
    end

    it 'connects to jira' do
      expect(Ticket.jira).to be_a(JIRA::Client)
    end

    context '#save' do
      before do
        allow(subject).to receive(:issue).and_return issue
      end

      it 'fails to update if not valid' do
        allow(subject).to receive(:issue).and_return nil
        expect(subject).to_not be_valid
        expect(subject.save).to eq(false)
      end

      it 'updates the jira ticket with given attributes' do
        allow(subject.send(:issue)).to receive(:save).with(assignee: subject.assignee).and_return(true)
        expect(subject).to be_valid
        expect(subject.save).to eq(true)
      end

      it 'returns false if the operation fails' do
        allow(subject.send(:issue)).to receive(:save).and_return false
        expect(subject.save).to eq(false)
      end
    end

    context '#persisted?' do
      it 'returns true when the jira ticket exists' do
        allow(subject).to receive(:issue).and_return double('JIRA::Ticket')
        expect(subject).to be_persisted
      end

      it 'returns false if the jira ticket cannot be found' do
        allow(subject).to receive(:issue).and_return nil
        expect(subject).to_not be_persisted
      end
    end
  end
end
