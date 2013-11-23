module Securrity
  class BaseRepository
    attr_reader :db

    def initialize(db)
      @db = db
    end

    def table_name
      entity_name.downcase + 's'
    end

    def entity_name
      self.class.name.split('::').last.gsub(/Repository$/,'')
    end

    def entity
      @entity ||= Securrity.const_get(entity_name)
    end

    def relation
      get_relation(table_name)
    end

    def get_relation(table_name)
      @db[:"securrity__#{table_name}"]
    end

    def all
      relation.all.map{|r| wrap(r)}
    end

    def wrap(row)
      entity.new(row)
    end

    def create(atts)
      identity = relation.insert(atts)
      atts["#{entity_name.downcase}_id"] = identity
      entity.new(atts)
    end

    def destroy_all
      relation.delete
    end
  end
end
