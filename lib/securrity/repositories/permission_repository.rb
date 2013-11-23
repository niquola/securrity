module Securrity
  class PermissionRepository < BaseRepository

    def role_permissions(role_id, fileter = {})
       relation.join(:securrity__role_permissions, permission_id: :permission_id)
       .all
       .map{|p| wrap(p)}
       # .select(permissions: '*')
    end
  end
end
