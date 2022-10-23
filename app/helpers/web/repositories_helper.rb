# frozen_string_literal: true

module Web::RepositoriesHelper
  def check_status(check)
    return t('common.in_progress') if check.created? || check.checking?

    check.passed
  end

  def last_check_status(repository)
    check = repository.checks.order('created_at DESC').first
    check_status(check)
  end

  def commit_link(check)
    return nil if check.commit.nil?

    link_to check.commit, "https://github.com/#{check.repository.name}/commit/#{check.commit}"
  end
end
