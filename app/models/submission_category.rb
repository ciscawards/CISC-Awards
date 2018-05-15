class SubmissionCategory < ApplicationRecord
  belongs_to :submission
  belongs_to :category
  after_save { |s_c| s_c.destroy if s_c.description.blank? }

  validates_presence_of :description, :if => :category_always_selected

  def category_always_selected
    category.always_selected?
  end
end