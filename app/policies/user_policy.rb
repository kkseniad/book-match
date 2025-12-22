# app/policies/user_policy.rb
class UserPolicy < ApplicationPolicy
  def show?
    user == record
  end

  def edit?
    user == record
  end

  def update?
    user == record
  end

  def destroy?
    false
  end

  class Scope < Scope
    def resolve
      scope.where(id: user.id)
    end
  end
end
