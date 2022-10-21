class Contact < MailForm::Base

  attributes :name, validate: true
  attributes :email, validate: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attributes :message, validate: true
  attributes :nickname, captcha: true

  def headers
    {
      subject: "RiverBoss Contact Form",
      to: "info@riverboss.com",
      from: %("RiverBoss Contact Request" <no-reply@riverboss.com>),
      reply_to: %("#{name}" <#{email}>)
    }
  end

end