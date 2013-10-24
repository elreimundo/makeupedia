class AddCachedToPages < ActiveRecord::Migration
  def change
  	add_column :pages, :cached, :text
  end
end
