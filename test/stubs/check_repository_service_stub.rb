# frozen_string_literal: true

class CheckRepositoryServiceStub
  def self.call(check)
    check.success!
    check.update(passed: true, issues: '[]')
    check.repository.update(language: 'JavaScript')
    { success: true }
  end
end
