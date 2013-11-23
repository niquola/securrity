module Securrity
  class RoleRepository < BaseRepository

    def associate_permission(role_id, permission_id)
      get_relation(:role_permissions).insert(role_id: role_id, permission_id: permission_id)
    end

    def user_roles(user_id, fileter = {})
       relation.join(:securrity__user_roles, role_id: :role_id)
       .all
       .map{|p| wrap(p)}
    end
  end
end
