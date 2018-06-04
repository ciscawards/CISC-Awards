module SubmissionsHelper

  # Returns the index controls for the given user.
  def controls_for(submission, user)
    controls = []
    controls << (link_to 'download PDF', submission_download_path(submission, format: 'pdf'), target: '_blank', class: 'download')
    if user.is_admin? || (submission.user == user && !submission.submitted)
      controls << (link_to 'edit', edit_submission_path(submission)) if submission.cohort.edit_submission_cutoff_date > Time.now
      controls << (link_to "delete", submission, method: :delete, data: { confirm: "You sure?" })
    end
    controls.join(" | ")
  end

  def sanitize_submissions_controls(control)
    sanitize(control, attributes: %w(href class data-confirm data-method rel))
  end
end
