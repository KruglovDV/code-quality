# frozen_string_literal: true

class Repository::CheckPolicy < ApplicationPolicy
  def create?
    record_belongs_to_user?
  end

  def show?
    record_belongs_to_user?
  end

  private

  def record_belongs_to_user?
    @record.repository.user_id == @user.id
  end
end
