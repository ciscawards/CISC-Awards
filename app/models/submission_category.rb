class SubmissionCategory < ApplicationRecord
  belongs_to :submission
  belongs_to :category
  after_save { |s_c| s_c.destroy if s_c.description.blank? }

  validates :description, presence: true, if: -> record { record.category_always_selected && record.submission_submitted}

  validates :description, :length => {
      :maximum   => 348,
      :tokenizer => lambda { |str| str.scan(/\s+|$/) },
      :js_tokenizer => "split(' ')",
      :too_long  => "can't have more than 350 words"
  }

  def category_always_selected
    category.always_selected?
  end

  def submission_submitted
    submission.submitted?
  end
end