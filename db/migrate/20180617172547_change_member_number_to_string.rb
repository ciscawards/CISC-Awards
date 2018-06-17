class ChangeMemberNumberToString < ActiveRecord::Migration[5.0]
  def change
    change_column :submissions, :cisc_number, :string
    rename_column :submissions, :cisc_number, :cisc_member
  end
end
