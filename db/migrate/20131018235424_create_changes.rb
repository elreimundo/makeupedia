class CreateChanges < ActiveRecord::Migration
  def change
    create_table :changes do |t|
      t.text :find_text
      t.text :replace_text
      t.belongs_to :page_user

      t.timestamps
    end
  end
end
