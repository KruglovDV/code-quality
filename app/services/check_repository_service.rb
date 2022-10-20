# frozen_string_literal: true

class CheckRepositoryService
  def initialize
    @check_command = 'node_modules/eslint/bin/eslint.js -c .eslintrc.yml --ignore-pattern .eslintrc --format=json --ext js repository'
  end

  def call(repository_name)
    client = ApplicationContainer[:github_client].new
    @repository_info = client.repository(repository_name)
    Git.clone(@repository_info[:clone_url], 'repository')

    Open3.pipeline('cd ./repository && npm i -D')

    stdout, exit_status = Open3.popen3(@check_command) do |_stdin, stdout, _stderr, wait_thr|
      [stdout.read, wait_thr.value]
    end

    { success: true, data: stdout, status: exit_status.exitstatus }
  rescue StandardError
    { success: false }
  ensure
    Open3.popen3('rm -rf ./repository')
  end
end
