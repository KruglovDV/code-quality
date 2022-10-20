# frozen_string_literal: true

module ApplicationHelper
  def last_check_status(repository)
    check = repository.checks.order('created_at DESC').first
    return t('common.in_progress') if check.created? || check.checking?

    check.issues.count.zero?
  end
end
