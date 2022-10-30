# frozen_string_literal: true

require_relative './lint_strategies/strategies_factory'

class CheckRepositoryService
  def initialize
    @repository_dir = './repository'
    @commit_command = "cd #{@repository_dir} && git rev-parse --short HEAD"
    @clear_command = "rm -rf #{@repository_dir}"
  end

  def call(repository_id)
    client = ApplicationContainer[:github_client].new
    @repository_info = client.repository(repository_id)
    @repository = Repository.find_by({ github_id: repository_id })
    @repository.update({
                         name: @repository_info[:name],
                         full_name: @repository_info[:full_name],
                         language: @repository_info[:language]
                       })
    Open3.popen3(@clear_command)
    Git.clone(@repository_info[:clone_url], 'repository')

    commit = Open3.popen3(@commit_command) do |_stdin, stdout, _stderr, _wait_thr|
      stdout.read
    end

    strategy = ::StrategiesFactory.new.build(@repository_info[:language], @repository_dir)
    lint_result = strategy.call

    passed = lint_result[:issues].count.zero?

    { success: true, data: { issues: JSON.generate(lint_result[:issues]), commit: commit, passed: passed } }
  rescue StandardError
    { success: false }
  ensure
    Open3.popen3(@clear_command)
  end
end
