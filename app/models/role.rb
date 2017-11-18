class Role < ApplicationRecord
  belongs_to :user

  enum role: [:applicant, :judge, :admin]
end
