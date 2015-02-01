class CreateUsers < ActiveRecord::Migration
  def up
    execute <<-SQL.strip_heredoc
      CREATE TABLE users(
        uuid uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
        email text NOT NULL UNIQUE,
        name text NOT NULL UNIQUE,
        created_at timestamp with time zone NOT NULL,
        updated_at timestamp with time zone NOT NULL
      );
    SQL
  end

  def down
    execute <<-SQL.strip_heredoc
      DROP TABLE users;
    SQL
  end
end
