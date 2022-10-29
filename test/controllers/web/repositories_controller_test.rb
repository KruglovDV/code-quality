# frozen_string_literal: true

require 'test_helper'

class Web::RepositoriesControllerTest < ActionDispatch::IntegrationTest
  test 'opens index page' do
    sign_in(users(:sam))
    get repositories_path
    assert_response :success
  end

  test 'opens new repository page' do
    sign_in(users(:sam))
    get new_repository_path
    assert_response :success
  end

  test 'creates new repository' do
    assert_difference('Repository::Check.count') do
      sign_in(users(:sam))

      create_repository_params = { full_name: 'test_repo' }
      post repositories_path, params: { repository: create_repository_params }

      created_repository = Repository.find_by(create_repository_params)

      assert created_repository
      assert_redirected_to repositories_path
    end
  end
end
