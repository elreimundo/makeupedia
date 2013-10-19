class CreatePageUsers < ActiveRecord::Migration
  def change
    create_table :page_users do |t|
      t.belongs_to :user
      t.belongs_to :page

      t.timestamps
    end
  end
end
