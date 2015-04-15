require 'stash-client'

module Revue
  class PullRequest < Model
    attr_accessor :id, :base, :reviewer

    validates :id, presence: true
    validates :reviewer, presence: {
      message: 'is blank, therefore pull request is not complete'
    }
    validate :exists_on_stash

    def self.stash
      @stash ||= Stash::Client.new(
        scheme: Revue.config.ssl ? 'https' : 'http',
        host: 'stash.' + Revue.config.domain,
        credentials: [
          Revue.config.username,
          Revue.config.password
        ].join(':'),
      )
    end

    def self.collection
      stash.repositories.map do |repo|
        repo.pull_requests.map do |pull|
          new pull.attributes.merge(base: pull)
        end.compact
      end.compact.flatten
    end

    def save
      valid? && update
    end

    def persisted?
      !base.nil?
    end

    def tickets
      @tickets ||= base.issues.map do |issue_id|
        Ticket.find(issue_id)
      end
    end

    private

    def exists_on_stash
      errors.add :base, 'does not exist on Stash' unless persisted?
    end

    def update
      tickets.all? do |ticket|
        ticket.update_attributes assignee: reviewer
      end
    end
  end
end
