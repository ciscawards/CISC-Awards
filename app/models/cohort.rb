class Cohort < ApplicationRecord
  has_many :submissions
  has_many :categories, inverse_of: :cohort, dependent: :destroy
  #TODO: validate start is before end
  accepts_nested_attributes_for :categories, reject_if: :all_blank, allow_destroy: true

  validates :steel_work_completed_deadline, presence: true
  validates :new_submission_cutoff_date, presence: true
  validates :edit_submission_cutoff_date, presence: true
  validate :only_one_active_cohort

  scope :active, -> { where(:active => true) }

  protected

  def only_one_active_cohort
    return unless active?

    matches = Cohort.active
    if persisted?
      matches = matches.where('id != ?', id)
    end
    if matches.exists?
      errors.add(:cohort, ': cannot have another active cohort')
    end
  end
end
