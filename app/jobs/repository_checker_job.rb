# frozen_string_literal: true

class RepositoryCheckerJob < ApplicationJob
  queue_as :default

  def perform(check_id)
    @check = Repository::Check.find_by(id: check_id)
    return if @check.nil?

    @check.check!
    @result = ApplicationContainer[:check_repository_service].new.call(@check)
    return if @result[:success]

    UserMailer.with(check: @check).check_failed_email.deliver_later
  end
end
