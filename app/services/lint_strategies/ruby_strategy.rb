# frozen_string_literal: true

class LintStrategies::RubyStrategy
  def self.call(repository_dir)
    output = Open3.popen3(check_command(repository_dir)) do |_stdin, stdout, _stderr, _wait_thr|
      stdout.read
    end

    prepare_issues(JSON.parse(output))
  end

  private_class_method def self.prepare_issues(issues)
    parsed_issues = issues['files'].map do |file|
      file_issues = []
      if file['offenses'].count
        file_issues = file['offenses'].map do |offence|
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
        issues: file_issues
      }
    end
    parsed_issues.filter do |file|
      file[:issues].count.positive?
    end
  end

  private_class_method def self.check_command(repository_dir)
    "bundle exec rubocop --config .rubocop.yml --format json #{repository_dir}"
  end
end
