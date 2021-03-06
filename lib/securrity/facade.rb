module Securrity
  class Facade
    attr_reader :db

    def initialize(db)
      @db = db
    end

    def user_repository
      UserRepository.new(db)
    end

    private :user_repository

    def users(query = {})
      user_repository.all
    end

    def create_user(user_attributes)
      user_repository.create(user_attributes)
    end

    def clear_users!
      user_repository.destroy_all
    end

    def permission_repository
      PermissionRepository.new(db)
    end

    private :permission_repository

    def create_permission(code, display_name)
      permission_repository.create(code: code.to_s, display_name: display_name)
    end

    def permissions(query={})
      permission_repository.all
    end

    def role_repository
      RoleRepository.new(db)
    end

    def roles(query={})
      role_repository.all
    end

    def create_role(display_name, description = nil)
      role_repository.create(display_name: display_name,
                             description: description)
    end

    def role_permissions(role_id, fileter={})
      permission_repository.role_permissions(role_id, fileter)
    end

    def grant_permission(role_id, permission_id)
      role_repository.associate_permission(role_id, permission_id)
    end

    def assign_role(user_id, role_id)
      user_repository.assign_role(user_id, role_id)
    end

    def user_roles(user_id, fileter = {})
      role_repository.user_roles(user_id, fileter)
    end

    def allowed?(user_id, permission_name_or_id)
      user_repository.has_permission?(user_id, permission_name_or_id)
    end
  end
end
