# frozen_string_literal: true

require 'test_helper'

class RepositoryCheckerJobTest < ActiveJob::TestCase
  test 'repository is checked' do
    repository = repositories(:react)
    check = repository.checks.create
    RepositoryCheckerJob.perform_now(check.id)
    check.reload
    assert { check.passed == true }
    assert { check.issues == '[]' }
  end
end
