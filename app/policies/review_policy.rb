class ReviewPolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        scope.all
      end
    end

    def show?
      true
    end

    def create?
      return true
    end

    def destroy?
      record.user == user
    end

    def update?
      record.user == user || admin == true
      # - record: the restaurant passed to the `authorize` method in controller
      # - user:   the `current_user` signed in with Devise.
    end
  end
