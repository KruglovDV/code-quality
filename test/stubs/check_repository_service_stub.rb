# frozen_string_literal: true

class CheckRepositoryServiceStub
  def call(check)
    check.update(passed: true, issues: '[]')
    { success: true }
  end
end
