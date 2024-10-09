class GetGoogleCloudStorageFile < ApplicationService
  require "google/cloud/storage"
  attr_reader :batch_prediction_job

  def initialize(batch_prediction_job)
    @batch_prediction_job = batch_prediction_job
  end

  def call
    storage = Google::Cloud::Storage.new
    path = @batch_prediction_job.output_info.gcs_output_directory
    bucket = storage.bucket path.split('/').third
    file = bucket.file @batch_prediction_job.output_info.gcs_output_directory.split('/').drop(3).join('/') + "/predictions_00001.jsonl"

    return file.download
  end
end