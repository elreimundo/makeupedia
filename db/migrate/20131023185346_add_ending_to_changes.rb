class AddEndingToChanges < ActiveRecord::Migration
  def change
    add_column :changes, :ending, :string
  end
end
