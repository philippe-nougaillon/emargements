class GetBatchPredictionJob < ApplicationService
  require "google/cloud/ai_platform/v1"
  attr_reader :batch_prediction_job

  def initialize(batch_prediction_job)
    @batch_prediction_job = batch_prediction_job
  end

  def call
    ::Google::Cloud::AIPlatform::V1::JobService::Client.configure do |config|
      config.endpoint = "#{ENV["GOOGLE_LOCATION"]}-aiplatform.googleapis.com"
      config.credentials = "#{ENV["GOOGLE_APPLICATION_CREDENTIALS"]}"
    end
    
    client = Google::Cloud::AIPlatform::V1::JobService::Client.new

    request = Google::Cloud::AIPlatform::V1::GetBatchPredictionJobRequest.new(name: "projects/#{ENV["GOOGLE_PROJECT_ID"]}/locations/#{ENV["GOOGLE_LOCATION"]}/batchPredictionJobs/#{@batch_prediction_job}")

    return client.get_batch_prediction_job request
  end
end