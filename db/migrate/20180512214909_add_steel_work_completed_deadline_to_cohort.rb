class AddSteelWorkCompletedDeadlineToCohort < ActiveRecord::Migration[5.0]
  def change
    add_column :cohorts, :steel_work_completed_deadline, :timestamp
  end
end
