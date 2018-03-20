class TdtMailer < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views

  def devise_mail(record, action, opts={})
    initialize_from_record(record)
    mail(headers_for(action, opts)) do |format|
      format.text
      format.html
    end
  end
end