class CreateBatchPredictionJob < ApplicationService
  require "google/cloud/ai_platform/v1"
  attr_reader :organisation_id

  def initialize(organisation_id)
    @organisation = Organisation.find(organisation_id)
  end

  def call
    ::Google::Cloud::AIPlatform::V1::JobService::Client.configure do |config|
      config.endpoint = "#{ENV["GOOGLE_LOCATION"]}-aiplatform.googleapis.com"
      config.credentials = "#{ENV["GOOGLE_APPLICATION_CREDENTIALS"]}"
    end

    filename = CreateGoogleCloudStorageInputFile.call(organisation_id: @organisation.id)

    client = Google::Cloud::AIPlatform::V1::JobService::Client.new

    batch = {
      "display_name": "batch_organisation_#{@organisation.id}",
      "model": "projects/#{ENV["GOOGLE_PROJECT_ID"]}/locations/#{ENV["GOOGLE_LOCATION"]}/models/#{ENV["GOOGLE_MODEL"]}",
      "model_version_id": "1",
      "input_config": {
        "instances_format": "jsonl",
        "gcs_source": {
          "uris": [
            "gs://#{ENV["GOOGLE_BUCKET_PATH"]}/#{filename}"
          ]
        }
      },
      "output_config": {
        "predictions_format": "jsonl",
        "gcs_destination": {
          "output_uri_prefix": ENV["GOOGLE_OUTPUT_FILE_PATH"]
        }
      }
    }

    request = Google::Cloud::AIPlatform::V1::CreateBatchPredictionJobRequest.new(parent: "projects/#{ENV["GOOGLE_PROJECT_ID"]}/locations/#{ENV["GOOGLE_LOCATION"]}", batch_prediction_job: batch)
    client.create_batch_prediction_job request
  end
end