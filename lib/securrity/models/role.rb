module Securrity
  class Role < BaseModel
    attribute :role_id, String
    attribute :display_name, String
    attribute :describing, String
  end
end
