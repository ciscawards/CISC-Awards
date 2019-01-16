class Attachment < ApplicationRecord
  belongs_to :submission
  require 'uri'

  def get_image_handler_path
    uri = URI("http:#{url}")
    "https://d68uert75j8g5.cloudfront.net/fit-in/600x700/#{ENV['S3_BUCKET']}#{uri.path}"
  end
end
