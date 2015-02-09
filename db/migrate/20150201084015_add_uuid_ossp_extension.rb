class AddUuidOsspExtension < ActiveRecord::Migration
  def up
    execute <<-SQL.strip_heredoc
      CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
    SQL
  end

  def down
    execute <<-SQL.strip_heredoc
      DROP EXTENSION "uuid-ossp";
    SQL
  end
end
