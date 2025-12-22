class UserBookPolicy < ApplicationPolicy
  def create?
    record.user_id == user.id
  end

  def update?
    record.user_id == user.id
  end

  def destroy?
    record.user_id == user.id
  end

  def show?
    false
  end

  def index?
    false
  end

  def edit?
    false
  end

  class Scope < Scope
    def resolve
      scope.where(user_id: user.id)
    end
  end
end
