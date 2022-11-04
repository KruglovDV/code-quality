# frozen_string_literal: true

class CheckRepositoryService
  def self.call(check)
    repository = check.repository
    client = ApplicationContainer[:github_client].new

    if repository.clone_url.nil?
      @repository_info = client.repository(repository.github_id)
      repository.update(
        name: @repository_info[:name],
        full_name: @repository_info[:full_name],
        language: @repository_info[:language],
        clone_url: @repository_info[:clone_url]
      )
    end

    Open3.popen3(clear_command(check))
    Git.clone(repository.clone_url, repository_dir(check))

    commit = Open3.popen3(commit_command(check)) do |_stdin, stdout, _stderr, _wait_thr|
      stdout.read
    end

    lint_result = lint_strategy(repository).call(repository_dir(check))

    check.update(
      issues: JSON.generate(lint_result),
      commit: commit,
      passed: lint_result.count.zero?
    )
    check.success!
    { success: true }
  rescue StandardError => e
    Rails.logger.fatal(e)
    check.update({ passed: false })
    check.fail!
    { success: false }
  ensure
    Open3.popen3(clear_command(check))
  end

  private_class_method def self.lint_strategy(repository)
    "::LintStrategies::#{repository.language}Strategy".constantize
  end

  private_class_method def self.repository_dir(check)
    "repository_#{check.id}"
  end

  private_class_method def self.commit_command(check)
    "cd #{repository_dir(check)} && git rev-parse --short HEAD"
  end

  private_class_method def self.clear_command(check)
    "rm -rf #{repository_dir(check)}"
  end
end
