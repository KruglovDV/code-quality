# frozen_string_literal: true

require_relative '../../test/stubs/github_client_stub'
require_relative '../../test/stubs/check_repository_service_stub'

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :github_client, -> { GithubClientStub }
    register :check_repository_service, -> { CheckRepositoryServiceStub }
  else
    register :github_client, -> { ::Octokit::Client }
    register :check_repository_service, -> { CheckRepositoryService }
  end
end
