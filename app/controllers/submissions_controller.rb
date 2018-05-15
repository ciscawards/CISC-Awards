class SubmissionsController < ApplicationController
  before_action :logged_in_user
  before_action :submissions_for_user_or_admin, only: [:edit, :update, :destroy]
  before_action :submissions_for_user_judge_or_admin, only: [:show]
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
    @submission.submitted = true if params[:submit_judges]
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
    s_p[:submitted] = true if params[:submit_judges]
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

  private

  def submission_params
    params.require(:submission).permit(:name, :steelwork_completion_date, :description, :project_location, :cisc_number, :contact_cisc, attachments_attributes: [:id, :url, :_destroy], team_members_attributes: [:id, :name, :title, :email, :_destroy], submission_categories_attributes: [:id, :description, :category_id, :_destroy])
  end

  # Before filters

  # Confirms the submission is owned by the current user.
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
end