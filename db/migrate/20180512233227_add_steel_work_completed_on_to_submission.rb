class AddSteelWorkCompletedOnToSubmission < ActiveRecord::Migration[5.0]
  def change
    add_column :submissions, :steel_work_completed_on, :timestamp
  end
end
