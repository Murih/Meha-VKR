class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Аккаунт активирован"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Пароль сброшен"
  end
end
