class CreateLicenseIngestionFiles < ActiveRecord::Migration[7.0]
  def change
    create_table :license_ingestion_files do |t|
      t.references :uploader,
                   null: false,
                   foreign_key: { to_table: :users },
                   index: { name: :license_ingestion_files_uploader_user_reference }
      t.datetime :processed_at

      t.timestamps
    end
  end
end
