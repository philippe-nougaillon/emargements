class GetBatchPredictionJobs < ApplicationService
  require "google/cloud/ai_platform/v1"

  def initialize()
  end

  def call
    ::Google::Cloud::AIPlatform::V1::JobService::Client.configure do |config|
      config.endpoint = "#{ENV["GOOGLE_LOCATION"]}-aiplatform.googleapis.com"
      config.credentials = "#{ENV["GOOGLE_APPLICATION_CREDENTIALS"]}"
    end
    
    client = Google::Cloud::AIPlatform::V1::JobService::Client.new

    request = Google::Cloud::AIPlatform::V1::ListBatchPredictionJobsRequest.new(parent: "projects/#{ENV["GOOGLE_PROJECT_ID"]}/locations/#{ENV["GOOGLE_LOCATION"]}")

    return client.list_batch_prediction_jobs request
  end
end