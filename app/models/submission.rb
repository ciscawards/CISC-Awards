class Submission < ApplicationRecord
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

  validates :steelwork_completion_date, presence: true
  validate :steelwork_completion_date_before_deadline

  def steelwork_completion_date_before_deadline
    errors.add(:steel_work, "must be completed prior to #{cohort.steel_work_completed_deadline.strftime("%B %d, %Y")}") if steelwork_completion_date > cohort.steel_work_completed_deadline
  end
end
