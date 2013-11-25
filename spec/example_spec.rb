require 'spec_helper'
require 'uuid'

describe Securrity do
  subject { described_class }
  around(:each) do |example|
    DB.transaction do # BEGIN
      example.run
      raise Sequel::Rollback
    end
  end

  example do
    sys = Securrity::Facade.new(DB)
    sys.clear_users!

    user = sys.create_user(name: 'nicola', password: '123456')
    sys.users.should include(user)

    p sys.users

    list_perm = sys.create_permission(:list_patients, 'Read Patient List')
    sys.permissions.should include(list_perm)

    role = sys.create_role('Physicians', 'Just a inpatient physicians')
    sys.roles.should include(role)

    sys.grant_permission(role.identity, list_perm.identity)

    permissions = sys.role_permissions(role.identity)
    permissions.should include(list_perm)

    sys.allowed?(user.identity, list_perm.identity).should_not be_true
    sys.assign_role(user.identity, role.identity)

    sys.user_roles(user.identity).should include(role)

    sys.allowed?(user.identity, UUID.generate).should_not be_true

    sys.allowed?(user.identity, list_perm.identity).should be_true

    sys.allowed?(user.identity, :list_patients).should be_true
  end
end
