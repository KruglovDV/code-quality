# frozen_string_literal: true

require 'test_helper'

class Api::ChecksControllerTest < ActionDispatch::IntegrationTest
  test 'checks updated repository' do
    repository = repositories(:vue)
    before_checks_count = repository.checks.count
    post api_checks_path, params: { repository: { full_name: repository.full_name } }
    assert { before_checks_count < repository.checks.count }
    assert { repository.checks.last.passed == true }
  end
end
