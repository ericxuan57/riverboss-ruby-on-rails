class Suggest < MailForm::Base

  attributes :name, validate: true
  attributes :email, validate: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attributes :river_name, validate: true
  attributes :condition_high, validate: true
  attributes :condition_low, validate: true
  attributes :nickname, captcha: true
  attributes :comment

  def headers
    {
      subject: "RiverBoss Condition Suggest Request",
      to: "admin@riverboss.com",
      from: %("RiverBoss Condition Suggest Request" <no-reply@riverboss.com>),
      reply_to: %("#{name}" <#{email}>)
    }
  end

end