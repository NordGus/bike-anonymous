class License::IngestionFile < ApplicationRecord
  belongs_to :uploader, class_name: "User", foreign_key: :uploader_id

  has_one_attached :file

  validates :file, presence: true

  def mark_as_processed
    update(processed_at: DateTime.now)
  end
end
