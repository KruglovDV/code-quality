# frozen_string_literal: true

class RubocopStrategy
  def initialize(repository_dir)
    @repository_dir = repository_dir
    @install_deps_command = "cd #{@repository_dir} && npm i -D"
    @check_command = "node_modules/eslint/bin/eslint.js -c .eslintrc.yml --ignore-pattern .eslintrc --format=json --ext js #{@repository_dir}"
  end

  def call
    Open3.pipeline(@install_deps_command)
    stdout, exit_status = Open3.popen3(@check_command) do |_stdin, stdout, _stderr, wait_thr|
      [stdout.read, wait_thr.value]
    end

    issues = JSON.parse(stdout)
    { exit_status: exit_status.exitstatus, issues: issues }
  end
end
