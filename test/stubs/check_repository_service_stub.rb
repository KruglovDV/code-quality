# frozen_string_literal: true

class CheckRepositoryServiceStub
  def self.call(check)
    check.success!
    check.update(passed: true, issues: '[]')
    { success: true }
  end
end
