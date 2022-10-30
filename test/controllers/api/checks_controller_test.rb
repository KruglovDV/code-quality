# frozen_string_literal: true

require 'test_helper'

class Api::ChecksControllerTest < ActionDispatch::IntegrationTest
  test 'checks updated repository' do
    repository = repositories(:react)
    assert_difference('Repository::Check.count') do
      post api_checks_path, params: { repository: { full_name: repository.full_name } }
    end
  end
end
