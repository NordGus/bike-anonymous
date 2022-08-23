class CreateLicenseIds < ActiveRecord::Migration[7.0]
  def change
    create_table :license_ids do |t|
      t.references :cyclist,
                   null: false,
                   foreign_key: { to_table: :users },
                   index: { name: :license_ids_cyclist_user_reference }
      t.datetime :registered_at, null: false
      t.datetime :expires_at, null: false
      t.string :code, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.integer :age, null: false

      t.timestamps

      t.index :code, name: :license_ids_code_index, unique: true
    end
  end
end
