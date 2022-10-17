# frozen_string_literal: true

require 'test_helper'

class Web::RepositoriesControllerTest < ActionDispatch::IntegrationTest

  def stub_repositories_request
    mock_url = 'https://api.github.com/user/repos?per_page=100'
    resposnse = load_fixture('files/repositories.json')
    stub_request(:get, mock_url)
      .to_return(body: resposnse, status: 200, headers: { content_type: 'application/json' })
  end

  test 'opens index page' do
    sign_in(users(:sam))
    get repositories_path
    assert_response :success
  end

  test 'opens new repository page' do
    stub_repositories_request
    sign_in(users(:sam))
    get new_repository_path
    assert_response :success
  end

  test 'creates new repository' do
    stub_repositories_request
    sign_in(users(:sam))

    create_repository_params = { name: 'test_repo' }
    post repositories_path, params: { repository: create_repository_params }

    created_repository = Repository.find_by(create_repository_params)

    assert created_repository
    assert_redirected_to repositories_path
  end
end
