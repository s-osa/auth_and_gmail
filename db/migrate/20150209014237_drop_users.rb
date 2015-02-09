class DropUsers < ActiveRecord::Migration
  def up
    execute <<-SQL.strip_heredoc
      DROP TABLE users;
    SQL
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
