# frozen_string_literal: true

class CheckRepositoryServiceStub
  def call(_repository_name)
    { success: true, check_data: { issues: '[]', commit: 'abc', passed: true }, repository_data: { name: 'repo', full_name: 'repo', language: 'Ruby' } }
  end
end
