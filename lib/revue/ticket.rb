require 'jira'

module Revue
  class Ticket < Model
    attr_accessor :id, :assignee

    validate :exists_on_jira

    class << self
      def jira
        @jira ||= JIRA::Client.new(
          site: jira_hostname,
          username: Revue.config.username,
          password: Revue.config.password
        )
      end

      private

      def jira_hostname
        scheme = Revue.config.ssl ? 'https' : 'http'
        "#{scheme}://jira.#{Revue.config.domain}"
      end
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
