# frozen_string_literal: true

class GithubClientStub
  def initialize(**kwargs); end

  def repos
    [{ full_name: 'test_repo', name: 'test_repo', language: 'JavaScript' }]
  end

  def create_hook(_repo, _service, _host_config, _event); end
end
