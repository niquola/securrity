module Securrity
  class OperationRepository
    def initialize(db)
      @db = db
    end

    def relation
      @db[:securrity__operations]
    end

    def find_all
      relation.all.map{|r| wrap(r)}
    end

    def wrap(row)
      Operation.new(row)
    end
  end
end
