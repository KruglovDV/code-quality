# frozen_string_literal: true

require 'test_helper'

class Web::RepositoriesControllerTest < ActionDispatch::IntegrationTest
  test 'opens index page' do
    sign_in(users(:sam))
    get repositories_path
    assert_response :success
  end

  test 'opens show page' do
    sign_in(users(:sam))
    repository = repositories(:react)
    get repository_path(repository)
    assert_response :success
  end

  test 'opens new repository page' do
    sign_in(users(:sam))
    get new_repository_path
    assert_response :success
  end

  test 'creates new repository' do
    sign_in(users(:sam))
    create_repository_params = { github_id: 3 }
    post repositories_path, params: { repository: create_repository_params }

    created_repository = Repository.find_by(create_repository_params)

    assert created_repository
    assert { created_repository.fetched? == true }
    assert_redirected_to repositories_path
  end
end
