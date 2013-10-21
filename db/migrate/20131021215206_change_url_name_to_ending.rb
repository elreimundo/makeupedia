class ChangeUrlNameToEnding < ActiveRecord::Migration
  def up
    rename_column :pages, :url, :ending
  end

  def down
  end
end
