class CreateGoogleCloudStorageInputFile < ApplicationService
  require "google/cloud/storage"

  def initialize()
  end

  def call
    storage = Google::Cloud::Storage.new
    bucket = storage.bucket ENV["GOOGLE_BUCKET_PATH"]

    content_file = []

    Presence.all.each do |presence|
      h = {}

      file = "signature_#{presence.id}_assemblee_#{presence.assemblee_id}_#{DateTime.now}.png"
      filepath = "user_#{presence.user_id}/#{file}"

      Tempfile.create(['image', '.svg']) do |temp_svg|
        temp_svg.write(Base64.decode64(presence.signature.split(',')[1]))
        temp_svg.rewind
        image = MiniMagick::Image.open(temp_svg.path)
        image.format "png"
        image.write file
      end

      bucket.create_file file, filepath
      File.delete(file)
      content = "gs://#{ENV["GOOGLE_BUCKET_PATH"]}/#{filepath}"

      h['content'] = content
      h['mimeType'] = "image/png"
      content_file << h
    end

    filename = "batch_input/batch_prediction_input_#{DateTime.now}.jsonl"

    puts content_file.map { |r| JSON.generate(r) }.join("\n")

    bucket.create_file StringIO.new(content_file.map { |r| JSON.generate(r) }.join("\n")), filename

    return filename
  end
end