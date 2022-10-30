# frozen_string_literal: true

class RepositoryCheckerJob < ApplicationJob
  queue_as :default

  def perform(check_id)
    @check = Repository::Check.find(check_id)
    @check.check!
    @result = ApplicationContainer[:check_repository_service].new.call(@check.repository.github_id)
    if @result[:success]
      @check.repository.update(@result[:repository_data])
      @check.update(@result[:check_data])
      @check.success!
    else
      UserMailer.with(check: @check).check_failed_email.deliver_later
      @check.update({ passed: false })
      @check.fail!
    end
  end
end
