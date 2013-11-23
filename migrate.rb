require 'yaml'
require 'sequel'
require 'rubygems'
require 'bundler/setup'
require 'securrity'

cfg = YAML.load(File.read(File.dirname(__FILE__) + '/spec/connection.yml'))
db = cfg.delete('db')
DB = Sequel.postgres(db, cfg)
Securrity::Migrator.migrate(DB)
