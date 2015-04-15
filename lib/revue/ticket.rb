require 'jira'

module Revue
  class Ticket < Model
    attr_accessor :id, :assignee

    validate :exists_on_jira

    def self.jira
      @jira ||= JIRA::Client.new(
        site: URI.join('jira', Revue.config.domain),
        username: Revue.config.username,
        password: Revue.config.password
      )
    end

    def save
      valid? && issue.save(assignee: assignee)
    end

    def persisted?
      !issue.nil?
    end

    private

    def exists_on_jira
      unless persisted?
        errors.add :base, 'was not found on JIRA for this project'
      end
    end

    def issues
      @issues ||= self.class.jira.Project.all.map(&:issues).flatten
    end

    def issue
      @issue ||= issues.find do |current_issue|
        current_issue.id == id
      end
    end
  end
end
