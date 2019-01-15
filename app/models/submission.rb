class Submission < ApplicationRecord
  BRIEF_DESCRIPTION_LENGTH = 125
  DESCRIPTION_LENGTH = 500

  belongs_to :cohort
  belongs_to :user
  has_many :team_members, inverse_of: :submission, dependent: :destroy
  has_many :attachments, inverse_of: :submission, dependent: :destroy
  has_many :submission_categories, inverse_of: :submission, dependent: :destroy
  accepts_nested_attributes_for :team_members, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :attachments, allow_destroy: true
  accepts_nested_attributes_for :submission_categories, allow_destroy: true

  scope :submitted, -> { where(:submitted => true) }
  scope :incomplete, -> { where("submitted IS NULL OR submitted = false") }

  validates :name, presence: true
  validate :brief_description_length
  validate :description_length

  validates :steelwork_completion_date, presence: true, steelwork_completion_date: true

  with_options :if => :submitted? do
    validates :project_location, presence: true
    validates :brief_description, presence: true
    validates :description, presence: true
    validates :cisc_member, presence: true
  end

  private

  def brief_description_length
    if word_count_too_long?(brief_description, BRIEF_DESCRIPTION_LENGTH)
      errors.add(:brief_description, "Maximum of #{BRIEF_DESCRIPTION_LENGTH} words")
    end
  end

  def description_length
    if word_count_too_long?(description, DESCRIPTION_LENGTH)
      errors.add(:description, "Maximum of #{DESCRIPTION_LENGTH} words")
    end
  end

  def word_count_too_long?(input_html, max_word_count)
    raw_text = ActionView::Base.full_sanitizer.sanitize(input_html)
    raw_text.scan(/\s+|$/).length > max_word_count
  end
end
