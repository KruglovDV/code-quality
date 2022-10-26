# frozen_string_literal: true

require 'test_helper'

class Api::ChecksControllerTest < ActionDispatch::IntegrationTest
  test 'creates new repository' do
    repository = repositories(:react)
    assert_enqueued_with(job: RepositoryCheckerJob) do
      post check_path, params: { repository: { full_name: repository.name } }
    end
  end
end
