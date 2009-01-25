class CreatePageRoleId < ActiveRecord::Migration
  def self.up
    add_column :pages, :role_id, :integer
    add_index :pages, :role_id
  end
  def self.down
    remove_index :pages, :role_id
    remove_column :pages, :role_id
  end
end