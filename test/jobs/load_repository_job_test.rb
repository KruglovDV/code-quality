# frozen_string_literal: true

require 'test_helper'

class LoadRepositoryJobTest < ActiveJob::TestCase
  test 'repository is checked' do
    user = users(:sam)
    repository = Repository.create(github_id: 3, user_id: user.id)
    LoadRepositoryJob.perform_now(repository.id)
    repository.reload
    assert { repository.loaded_from_github? == true }
  end
end
