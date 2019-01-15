class SubmissionCategory < ApplicationRecord
  DESCRIPTION_LENGTH = 350

  belongs_to :submission
  belongs_to :category
  after_save { |s_c| s_c.destroy if s_c.description.blank? }

  validates :description, presence: true, if: -> record { record.category_always_selected && record.submission_submitted}
  validates :description, word_count: true

  def category_always_selected
    category.always_selected?
  end

  def submission_submitted
    submission.submitted?
  end
end
