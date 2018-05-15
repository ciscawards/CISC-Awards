class Cohort < ApplicationRecord
  has_many :submissions
  has_many :categories, inverse_of: :cohort, dependent: :destroy
  #TODO: validate start is before end
  accepts_nested_attributes_for :categories, reject_if: :all_blank, allow_destroy: true

  validates :steel_work_completed_deadline, presence: true
  validates :new_submission_cutoff_date, presence: true
  validates :edit_submission_cutoff_date, presence: true

  scope :active, -> { where(active: true).first }

  def new_cutoff_date_invalid?
    new_submission_cutoff_date < Time.now
  end
end
