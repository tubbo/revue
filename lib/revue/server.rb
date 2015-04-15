require 'logger'

module Revue
  # The daemon process used to periodically change ticket statuses.
  class Server
    attr_reader :logger

    def initialize(log_location = STDOUT)
      @logger = Logger.new log_location
    end

    # Instantiate log functions and start the server.
    def run
      logger.info 'Starting the Revue daemon...'
      loop { sync }
      logger.info 'Revue has exited.'
    end

    private

    # Do everything once.
    def sync
      logger.debug 'Checking for open pull requests...'
      num = 0

      PullRequest.each do |pull_request|
        logger.debug "Working with #{pull_request}"
        if pull_request.tickets.any?
          pull_request.tickets.each do |ticket|
            user = pull_request.reviewers.first

            if ticket.update_attributes assignee: user
              logger.debug "Ticket '#{ticket}' has been assigned to '#{user}'"
            else
              logger.error "Error assigning '#{ticket}' to '#{user}'"
            end
          end

          num += 1
        else
          logger.debug "No tickets found for PR ##{pull_request.id}"
        end
      end

      logger.info "#{num} pull requests moved as of #{Time.now}" unless num == 0
    end
  end
end
