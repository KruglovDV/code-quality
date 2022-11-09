# frozen_string_literal: true

class RepositoryCheckerJob < ApplicationJob
  queue_as :default

  retry_on ::JobExceptions::RepositoryNotLoadedException

  def perform(check_id)
    @check = Repository::Check.find_by(id: check_id)
    return if @check.nil?

    @repository = @check.repository

    return if @repository.load_failed? || @repository.created?

    raise ::JobExceptions::RepositoryNotLoadedException if @repository.loading?

    @check.check!
    @result = ApplicationContainer[:check_repository_service].call(@check, @repository)
    return if @result[:success]

    UserMailer.with(check: @check).check_failed_email.deliver_later
  end
end
