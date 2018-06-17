class TeamMemberMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.team_member_mailer.submission_notification.subject
  #
  def submission_notification(team_member)
    @team_member = team_member
    mail to: team_member.email, subject: "Account activation"
  end
end
