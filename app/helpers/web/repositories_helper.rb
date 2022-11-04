# frozen_string_literal: true

module Web::RepositoriesHelper
  def check_status(check)
    return t('common.in_progress') if check&.created? || check&.checking?

    check&.passed
  end

  def commit_link(check, repository)
    return nil if check.commit.nil?

    link_to check.commit, "https://github.com/#{repository.full_name}/commit/#{check.commit}"
  end
end
