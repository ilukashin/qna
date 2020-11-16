class DailyDigestMailer < ApplicationMailer

  def digest(user, content_list)
    @content_list = content_list
    mail to: user.mail
  end
end
