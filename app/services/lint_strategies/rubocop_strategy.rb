# frozen_string_literal: true

class RubocopStrategy
  def initialize(repository_dir)
    @repository_dir = repository_dir
    @install_deps_command = "cd #{@repository_dir} && bundle"
    @check_command = "bundle exec rubocop --format json #{@repository_dir}"
  end

  def call
    Open3.pipeline(@install_deps_command)
    stdout, exit_status = Open3.popen3(@check_command) do |_stdin, stdout, _stderr, wait_thr|
      [stdout.read, wait_thr.value]
    end

    issues = prepare_issues(JSON.parse(stdout))
    { exit_status: exit_status.exitstatus, issues: issues }
  end

  private

  def prepare_issues(issues)
    parsed_issues = issues['files'].map do |file|
      issues = []
      if file['offenses'].count
        issues = file['offenses'].map do |offence|
          {
            message: offence['message'],
            rule: offence['cop_name'],
            line: offence['location']['line'],
            column: offence['location']['column']
          }
        end
      end
      {
        file: file['path'],
        issues: issues
      }
    end
    parsed_issues.filter do |file|
      file[:issues].count.positive?
    end
  end
end
