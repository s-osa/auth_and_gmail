class CreateUsers < ActiveRecord::Migration
  def up
    execute <<-SQL.strip_heredoc
      CREATE TABLE users(
        uuid uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
        email         text NOT NULL UNIQUE,
        name          text NOT NULL UNIQUE,
        access_token  text NOT NULL UNIQUE,
        refresh_token text NOT NULL UNIQUE
      );
    SQL
  end

  def down
    execute <<-SQL.strip_heredoc
      DROP TABLE users;
    SQL
  end
end
