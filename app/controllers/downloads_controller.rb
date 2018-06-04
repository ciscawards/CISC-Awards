class DownloadsController < ApplicationController
  require 'zip'
  before_action :logged_in_user
  before_action :submissions_for_user_judge_or_admin, only: [:show]
  after_action :clear_tmp

  def show
    submission = Submission.find(params[:submission_id])
    download = Download.new(submission)
    pdf = download.to_pdf
    respond_to do |format|
      format.pdf { send_file pdf, download_attributes(download) }
    end
  end

  def bulk_pdf
    submissions = Submission.find(params[:submission_ids].keys)
    respond_to do |format|
      format.zip do
        compressed_filestream = Zip::OutputStream.write_buffer do |zos|
          submissions.each do |submission|
            zos.put_next_entry "submission-#{submission.id}.pdf"
            download = Download.new(submission)
            zos.print download.to_pdf
          end
        end
        compressed_filestream.rewind
        send_data compressed_filestream.read, filename: "submissions.zip"
      end
    end
  end

  private

  def download_attributes(download)
    {
        filename: download.filename,
        type: "application/pdf",
        disposition: "inline"
    }
  end

  def submissions_for_user_judge_or_admin
    redirect_to(root_url) unless current_user?(submission.user) || current_user.is_judge? || current_user.is_admin?
  end

  def clear_tmp
    #TODO: run this on a delayed task, or clear the whole folder first
    #File.delete("tmp/submission_#{submission.id}.pdf")
  end
end