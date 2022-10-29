# frozen_string_literal: true

class RepositoryCheckerJob < ApplicationJob
  queue_as :default

  def perform(check_id)
    @check = Repository::Check.find(check_id)
    @check.check!
    @result = ApplicationContainer[:check_repository_service].new.call(@check.repository.full_name)
    if @result[:success]
      @check.update(@result[:data])
      @check.success!
    else
      UserMailer.with(check: @check).check_failed_email.deliver_later
      @check.update({ passed: false })
      @check.fail!
    end
  end
end
