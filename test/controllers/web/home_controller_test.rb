# frozen_string_literal: true

require 'test_helper'

class Web::HomeControllerTest < ActionDispatch::IntegrationTest
  test 'opens index page' do
    get root_path
    assert_response :success
  end
end
