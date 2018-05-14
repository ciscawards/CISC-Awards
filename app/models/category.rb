class Category < ApplicationRecord
  belongs_to :cohort
  has_many :submission_categories

  def class_for_always_checked
    if always_selected
      return "disabled"
    end
    ""
  end
end
