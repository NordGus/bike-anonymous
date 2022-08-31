require "test_helper"

class Api::License::FilesController::IngestTest < ActionDispatch::IntegrationTest
  test "should return unauthorized response when the user is not logged in" do
    post ingest_api_license_files_path

    assert_response :unauthorized
    assert_not response.body.present?
  end

  test "should return unauthorized response when user is not a partner" do
    token = login_token(:owner)

    post ingest_api_license_files_path,
         headers: { "Authorization": "Bearer #{token}" }

    assert_response :unauthorized
    assert_not response.body.present?
  end

  test "should return internal server error response when no file is sent" do
    token = login_token(:partner)

    post ingest_api_license_files_path,
         headers: { "Authorization": "Bearer #{token}" }

    assert_response :internal_server_error
    assert_not response.body.present?
  end

  test "should return success response when an partner is logged in" do
    token = login_token(:partner)
    ingestion_file = fixture_file_upload("license/ingestion_file.csv", "text/csv")

    assert_difference "License::IngestionFile.count", 1 do
      post ingest_api_license_files_path,
           headers: { "Authorization": "Bearer #{token}" },
           params: { file: ingestion_file }
    end

    assert_response :success
    assert_not response.body.present?
  end
end