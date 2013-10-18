class CreatePageUsers < ActiveRecord::Migration
  def change
    create_table :page_users do |t|

      t.timestamps
    end
  end
end
