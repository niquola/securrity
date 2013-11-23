module Securrity
  class Operation < BaseModel
    attribute :operation_id, String
    attribute :code, String
    attribute :display_name, String
    attribute :description, String
    attribute :locked, Boolean
  end
end
