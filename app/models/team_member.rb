class TeamMember < ApplicationRecord
  belongs_to :submission
  attr_accessor :title_selected_value
  TITLES = [ "Project Lead", "Fabricator", "Architect", "Engineer", "General Contractor", "Steel Detailer", "Steel Erector", "Owner" ]

  with_options :if => :submission_submitted? do
    validates :name, presence: true
    validates :title, presence: true
    validates :email, presence: true
  end

  def selected_title
    return self.title if TITLES.include?(self.title)
    return TITLES.first if self.title.nil?
    I18n.t("submission.team_member.titles.other")
  end

  def titles_with_other
    TeamMember::TITLES + [I18n.t("submission.team_member.titles.other")]
  end

  def send_submission_notification_email
    TeamMemberMailer.submission_notification(self).deliver_now
  end

  private

  def submission_submitted?
    submission.submitted?
  end
end
