module CohortsHelper

  def show_new_submission_button?
    active_cohort = Cohort.active
    return true if active_cohort.present? && active_cohort.new_submission_cutoff_date > Time.now
    false
  end
end
