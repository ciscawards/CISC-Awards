class RenameEndDateToNewSubmissionCutoffDate < ActiveRecord::Migration[5.0]
  def change
    rename_column :cohorts, :end_at, :new_submission_cutoff_date
    add_column :cohorts, :edit_submission_cutoff_date, :timestamp
  end
end
