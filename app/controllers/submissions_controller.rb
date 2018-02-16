class SubmissionsController < ApplicationController
  before_action :logged_in_user
  before_action :submissions_for_user, only: [:edit, :update, :destroy]

  def index
    #TODO: Need to show these grouped by cohort and sorted chronologically
    if current_user.is_admin?
      submissions = Submission
    elsif current_user.is_judge?
      submissions = Submission.where(user_id: current_user.id)
    else
      submissions = Submission.where(user_id: current_user.id)
    end
    @submissions = submissions.paginate(page: params[:page], :per_page => 12)
  end

  def show
    @submission = Submission.find(params[:id])
  end

  def new
    @submission = Submission.new
  end

  def create
    @submission = Submission.new(submission_params)
    @submission.cohort = Cohort.last
    @submission.user = current_user
    if @submission.save
      flash[:info] = "Submission has been saved."
      redirect_to submissions_path
    else
      render 'new'
    end
  end

  def edit
    @submission = Submission.find(params[:id])
  end

  def update
    @submission = Submission.find(params[:id])
    if @submission.update_attributes(submission_params)
      flash[:success] = "Submission updated"
      redirect_to submissions_path
    else
      render 'edit'
    end
  end

  def destroy
    Submission.find(params[:id]).destroy
    flash[:success] = "Submission deleted"
    redirect_to submissions_path
  end

  private

    def submission_params
      params.require(:submission).permit(:name, :description)
    end

    # Before filters

    # Confirms the submission is owned by the current user.
    def submissions_for_user
      @submission = Submission.find(params[:id])
      redirect_to(root_url) unless current_user?(@submission.user)
    end

end