class AddAlwaysSelectedToCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :always_selected, :boolean
  end
end
