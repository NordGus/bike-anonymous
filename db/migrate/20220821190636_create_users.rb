class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :password_digest
      t.integer :role, default: 0
      t.integer :token_version, default: 0
      t.string :email, null: false

      t.timestamps
    end

    add_index :users, :username, unique: true, name: :users_username_index
    add_index :users, :email, unique: true, name: :users_email_index
  end
end
