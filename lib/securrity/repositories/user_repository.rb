require 'bcrypt'
module Securrity
  class UserRepository < BaseRepository

    def create(attrs)
      password = attrs.delete(:password)
      if password
        attrs[:encrypted_password] =  encrypted_password(password)
      end
      super(attrs)
    end

    def encrypted_password(password)
      salt = BCrypt::Engine.generate_salt
      BCrypt::Engine.hash_secret(password, salt)
    end

    def assign_role(user_id, role_id)
      get_relation(:user_roles)
      .insert(role_id: role_id, user_id: user_id)
    end

    def has_permission?(user_id, permission_id)
      rel = get_relation(:user_roles)
      .select('exists()')
      .join(:securrity__role_permissions,[:role_id])
      .join(:securrity__permissions,[:permission_id])
      .where(user_id: user_id)

      if permission_id.is_a?(Symbol)
        rel.where(code: permission_id.to_s).first
      else
        rel.where(permission_id: permission_id).first
      end
    end
  end
end
