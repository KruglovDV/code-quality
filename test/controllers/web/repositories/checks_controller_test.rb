# frozen_string_literal: true

require 'test_helper'

class Web::Repositories::ChecksControllerTest < ActionDispatch::IntegrationTest
  test 'opens show page' do
    sign_in(users(:sam))
    repository = repositories(:react)
    check = repository_checks(:react_first_check)
    get repository_check_path(repository.id, check.id)

    assert_response :success
  end
end
