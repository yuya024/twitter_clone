# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  default from: 'yuyaaanissy@gmail.com'

  def notification_email(notification:, user:)
    @notification = notification
    mail(to: user.email, subject: '通知メール')
  end
end
