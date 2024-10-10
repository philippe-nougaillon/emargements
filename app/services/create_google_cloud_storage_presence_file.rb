class CreateGoogleCloudStoragePresenceFile < ApplicationService
  require "google/cloud/storage"
  require "mini_magick"
  attr_reader :presence

  def initialize(presence)
    @presence = presence
  end

  def call
    storage = Google::Cloud::Storage.new
    bucket = storage.bucket ENV["GOOGLE_BUCKET_PATH"]

    file = "signature_#{@presence.id}_assemblee#{@presence.assemblee_id}_#{DateTime.now}.png"
    filepath = "user_#{@presence.user_id}/#{file}"

    Tempfile.create(['image', '.svg']) do |temp_svg|
      temp_svg.write(Base64.decode64(@presence.signature.split(',')[1]))
      temp_svg.rewind
      image = MiniMagick::Image.open(temp_svg.path)
      image.format "png"
      image.write file
    end

    bucket.create_file file, filepath
    File.delete(file)

    return "gs://#{ENV["GOOGLE_BUCKET_PATH"]}/#{filepath}"
  end
end