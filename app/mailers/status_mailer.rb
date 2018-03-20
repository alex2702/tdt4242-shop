class StatusMailer < ApplicationMailer
  def status_update(recipient, order, subject, body)
    @recipient = User.find(recipient)
    @order = Order.find(order)
    @body = body
    mail(
      from: Rails.application.secrets.email_sender,
      to: @recipient.email,
      subject: subject
    ) do |format|
      format.text
      format.html
    end
  end
end