Sequel.migration do
  up do
    execute_ddl File.read(File.dirname(__FILE__) + '/schema.sql')
  end

  down do
    execute_ddl "drop schema securrity cascade;"
  end
end
