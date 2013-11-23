module Securrity
  class Permission < BaseModel
    attribute :permission_id, String
    attribute :code, String
    attribute :display_name, String
    attribute :description, String
  end
end
