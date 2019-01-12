class SubmissionsController < ApplicationController
  require 'zip'

  before_action :logged_in_user
  before_action :submissions_for_user_or_admin, only: [:edit, :update, :destroy]
  before_action :submissions_for_user_judge_or_admin, only: [:show, :single_download]
  before_action :set_s3_direct_post, only: [:new, :edit, :create, :update]

  def index
    if current_user.is_admin?
      @submissions = Submission.all
    elsif current_user.is_judge?
      @submissions = Submission.where("submitted = true OR user_id = #{current_user.id}")
    else
      @submissions = Submission.where(user_id: current_user.id)
    end
    @cohorts = Cohort.order({active: "DESC"}).order({new_submission_cutoff_date: "DESC"}).find(@submissions.map(&:cohort_id).uniq)
  end

  def show
    @submission = Submission.find(params[:id])
  end

  def new
    active_cohort = Cohort.where(active: true).first
    require_valid_cohort(active_cohort, active_cohort.new_submission_cutoff_date)

    @submission = Submission.new
    @submission.cohort = active_cohort

    active_cohort.categories.each do |category|
      @submission.submission_categories.build({:category => category})
    end
    @submission.team_members.new({name: current_user.name, email: current_user.email})
  end

  def create
    active_cohort = Cohort.where(active: true).first
    require_valid_cohort(active_cohort, active_cohort.new_submission_cutoff_date)

    @submission = Submission.new(submission_params)
    @submission.cohort = active_cohort
    @submission.user = current_user
    if params[:submit_judges]
      @submission.instance_variable_set("@final_submission", true)
      @submission.submitted = true
      notify_team(@submission)
    end
    if @submission.save
      flash[:info] = "Submission has been saved."
      redirect_to submissions_path
    else
      render 'new'
    end
  end

  def edit
    @submission = Submission.find(params[:id])
    require_valid_cohort(@submission.cohort, @submission.cohort.edit_submission_cutoff_date)

    existing_s_c = @submission.submission_categories.map(&:category_id)
    categories = @submission.cohort.categories.reject { |category| existing_s_c.include?(category.id) }
    categories.each do |category|
      @submission.submission_categories.build({:category => category})
    end
  end

  def update
    @submission = Submission.find(params[:id])
    require_valid_cohort(@submission.cohort, @submission.cohort.new_submission_cutoff_date)

    s_p = submission_params
    if params[:submit_judges]
      @submission.instance_variable_set("@final_submission", true)
      s_p[:submitted] = true
      notify_team(@submission)
    end
    if @submission.update_attributes(s_p)
      flash[:success] = "Submission updated"
      redirect_to submissions_path
    else
      render 'edit'
    end
  end

  def destroy
    if current_user.is_judge?
      redirect_to submissions_path
    end
    Submission.find(params[:id]).destroy
    flash[:success] = "Submission deleted"
    redirect_to submissions_path
  end

  def single_download
    submission = Submission.find(params[:id])
    generate_zipped_pdfs [submission]
  end

  def bulk_actions
    if params[:bulk_deletion]
      bulk_deletion
    else
      bulk_download
    end
  end

  private

  def submission_params
    params.require(:submission).permit(:name, :steelwork_completion_date, :brief_description, :description, :project_location, :cisc_member, :contact_cisc, attachments_attributes: [:id, :url, :_destroy], team_members_attributes: [:id, :name, :title, :email, :_destroy], submission_categories_attributes: [:id, :description, :category_id, :_destroy])
  end

  def submissions_for_user_or_admin
    @submission = Submission.find(params[:id])
    redirect_to(root_url) unless (current_user?(@submission.user) && !@submission.submitted) || current_user.is_admin?
  end

  def submissions_for_user_judge_or_admin
    @submission = Submission.find(params[:id])
    redirect_to(root_url) unless current_user?(@submission.user) || current_user.is_judge? || current_user.is_admin?
  end

  def set_s3_direct_post
    @s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/#{SecureRandom.uuid}/${filename}", success_action_status: '201', acl: 'public-read')
  end

  def require_valid_cohort(cohort, cutoff_date)
    if cohort.nil? || cutoff_date < Time.now && !current_user.is_admin?
      flash[:warning] = "The cohort is no longer valid."
      redirect_to submissions_path
    end
  end

  def notify_team(submission)
    submission.team_members.each do |team_member|
      team_member.send_submission_notification_email unless team_member.email == submission.user.email
    end
  end

  def bulk_download
    redirect_to(root_url) and return unless current_user.is_judge? || current_user.is_admin?
    submissions = Submission.find(params[:submission_ids].keys)
    generate_zipped_pdfs submissions
  end

  def bulk_deletion
    redirect_to submissions_path unless current_user.is_admin?
    submissions = Submission.find(params[:submission_ids].keys)
    submissions.each do |submission|
      submission.destroy
    end
    flash[:success] = "Submissions deleted"
    redirect_to submissions_path
  end

  def generate_zipped_pdfs(submissions)
    compressed_filestream = Zip::OutputStream.write_buffer do |zos|
      submissions.each do |submission|
        zos.put_next_entry "#{sanitize_filename(submission.name)}.pdf"
        kit = PDFKit.new(as_html(submission), :page_size => 'Letter')
        kit.stylesheets << 'public/bootstrap.min.css'
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

  def sanitize_filename(filename)
    fn = filename.split /(?<=.)\.(?=[^.])(?!.*\.[^.])/m
    fn.map! { |s| s.gsub /[^a-z0-9\-]+/i, '_' }
    fn.join '.'
  end
end
