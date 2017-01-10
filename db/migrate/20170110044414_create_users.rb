class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_column :users, :password_digest, :string
    add_column :users, :phone, :string
    add_column :users, :address, :string
    add_column :users, :remember_digest, :string
    add_column :users, :is_admin, :boolean, default: false
  end
end
