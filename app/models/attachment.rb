class Attachment < ApplicationRecord
  belongs_to :submission
  require 'uri'

  scope :images, -> { where("LOWER(url) SIMILAR TO ?", '%(jpg|jpeg|png|gif)') }

  def get_image_handler_path
    uri_escaped = URI.encode("http:#{url}").to_s
    uri_proper = URI(uri_escaped)
    "#{ENV['CLOUDFRONT_URL']}/fit-in/600x700/#{ENV['S3_BUCKET']}#{uri_proper.path}"
  end
end
