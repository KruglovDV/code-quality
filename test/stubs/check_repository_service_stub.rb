# frozen_string_literal: true

class CheckRepositoryServiceStub
  def call(_repository_name)
    { success: true, data: { issues: '[]', commit: 'abc', passed: true } }
  end
end
