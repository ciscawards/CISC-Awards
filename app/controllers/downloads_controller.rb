class DownloadsController < ApplicationController
  require 'zip'
  before_action :logged_in_user

  def show
    submission = Submission.find(params[:submission_id])
    submissions_for_user_judge_or_admin submission
    respond_to do |format|
      format.zip do
        generate_zipped_pdfs [submission]
      end
    end
  end

  def bulk_pdf
    redirect_to(root_url) and return unless current_user.is_judge? || current_user.is_admin?
    submissions = Submission.find(params[:submission_ids].keys)
    respond_to do |format|
      format.zip do
        generate_zipped_pdfs submissions
      end
    end
  end

  private

  def generate_zipped_pdfs(submissions)
    compressed_filestream = Zip::OutputStream.write_buffer do |zos|
      submissions.each do |submission|
        zos.put_next_entry "submission-#{submission.id}.pdf"
        kit = PDFKit.new(as_html(submission), :page_size => 'Letter')
        # TODO: Style pdfs
        # kit.stylesheets << '/path/to/css/file'
        zos.print kit.to_pdf
      end
    end
    compressed_filestream.rewind
    send_data compressed_filestream.read, filename: "submissions.zip"
  end

  def as_html(submission)
    render_to_string template: "submissions/pdf",
                     layout: "submission_pdf",
                     formats: "html",
                     locals: { submission: submission }
  end

  def submissions_for_user_judge_or_admin (submission)
    redirect_to(root_url) unless current_user?(submission.user) || current_user.is_judge? || current_user.is_admin?
  end
end
