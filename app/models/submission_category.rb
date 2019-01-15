class SubmissionCategory < ApplicationRecord
  DESCRIPTION_LENGTH = 350

  include SharedValidators

  belongs_to :submission
  belongs_to :category
  after_save { |s_c| s_c.destroy if s_c.description.blank? }

  validates :description, presence: true, if: -> record { record.category_always_selected && record.submission_submitted}

  validate :description_length

  def category_always_selected
    category.always_selected?
  end

  def submission_submitted
    submission.submitted?
  end

  private

  def description_length
    if word_count_too_long?(description, DESCRIPTION_LENGTH)
      errors.add(:description, "Maximum of #{DESCRIPTION_LENGTH} words")
    end
  end
end
