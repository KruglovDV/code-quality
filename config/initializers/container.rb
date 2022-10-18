# frozen_string_literal: true

require_relative '../../test/stubs/github_client_stub'
require_relative '../../test/stubs/linter_runner_stub'

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :github_client, -> { GithubClientStub }
    register :linter_runner, -> { LinterRunnerStub }
  else
    register :github_client, -> { ::Octokit::Client }
    register :linter_runner, -> { LinterRunnerStub }
  end
end
