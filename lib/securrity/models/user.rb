module Securrity
  class User < BaseModel
    attribute :user_id, String
    attribute :password, String
    attribute :name, String
    attribute :status, String

    def ==(other)
      self.user_id == other.user_id
    end
  end
end
