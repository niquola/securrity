module Securrity
  class BaseModel
    include Virtus.model
    def primary_key
      "#{self.class.name.split('::').last.underscore}_id"
    end

    def identity
      self.send primary_key
    end

    def ==(other)
      self.send(primary_key) == other.send(primary_key)
    end
  end
end
