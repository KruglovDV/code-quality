# frozen_string_literal: true

class LintStrategies::JavaScriptStrategy
  def self.call(repository_dir)
    output = Open3.popen3(check_command(repository_dir)) do |_stdin, stdout, _stderr, _wait_thr|
      stdout.read
    end

    prepare_issues(JSON.parse(output))
  end

  private_class_method def self.prepare_issues(issues)
    issues.reduce([]) do |acc, file|
      if file['messages'].count.positive?
        file_issues = file['messages'].map do |issue|
          {
            message: issue['message'],
            rule: issue['ruleId'],
            line: issue['line'],
            column: issue['column']
          }
        end
        acc << {
          file: file['filePath'],
          issues: file_issues
        }
      else
        acc
      end
    end
  end

  private_class_method def self.check_command(repository_dir)
    "node_modules/eslint/bin/eslint.js --no-eslintrc -c .eslintrc.yml --format=json --ext js #{repository_dir}"
  end
end
