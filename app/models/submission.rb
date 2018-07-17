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

  validates :name, presence: true
  validates :brief_description, :length => {
      :maximum   => 125,
      :tokenizer => lambda { |str| str.scan(/\s+|$/) },
      :js_tokenizer => "split(' ')",
      :too_long  => "Maximum of 125 words"
  }

  validates :description, :length => {
      :maximum   => 500,
      :tokenizer => lambda { |str| str.scan(/\s+|$/) },
      :js_tokenizer => "split(' ')",
      :too_long  => "Maximum of 500 words"
  }

  validates :steelwork_completion_date, presence: true, steelwork_completion_date: true

  with_options :if => :submitted? do
    validates :project_location, presence: true
    validates :brief_description, presence: true
    validates :description, presence: true
    validates :cisc_member, presence: true
  end
end
