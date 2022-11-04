# frozen_string_literal: true

class CheckRepositoryServiceStub
  def self.call(check)
    check.success!
    check.update(passed: true, issues: '[]')
    check.repository.update(
      language: 'JavaScript',
      full_name: 'user/repo',
      name: 'repo'
    )
    { success: true }
  end
end
