# frozen_string_literal: true

class CheckRepositoryService
  def initialize
    @check_command = 'node_modules/eslint/bin/eslint.js -c .eslintrc.yml --ignore-pattern .eslintrc --format=json --ext js repository'
    @commit_command = 'cd ./repository && git rev-parse --short HEAD'
    @install_deps_command = 'cd ./repository && npm i -D'
    @clear_command = 'rm -rf ./repository'
  end

  def call(repository_name)
    client = ApplicationContainer[:github_client].new
    @repository_info = client.repository(repository_name)

    Open3.popen3(@clear_command)
    Git.clone(@repository_info[:clone_url], 'repository')

    commit = Open3.popen3(@commit_command) do |_stdin, stdout, _stderr, _wait_thr|
      stdout.read
    end

    Open3.pipeline(@install_deps_command)

    stdout, exit_status = Open3.popen3(@check_command) do |_stdin, stdout, _stderr, wait_thr|
      [stdout.read, wait_thr.value]
    end

    return { success: false } if exit_status.exitstatus == 2

    passed = JSON.parse(stdout).count.zero?

    { success: true, data: { issues: stdout, commit: commit, passed: passed } }
  rescue StandardError
    { success: false }
  ensure
    Open3.popen3(@clear_command)
  end
end
