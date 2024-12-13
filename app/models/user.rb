class User < ApplicationRecord
  has_secure_password
  has_many :pets

  validates :username,
            presence: { message: "Username cannot be blank." },
            uniqueness: { message: "User already exists." }

  validates :password, 
            presence: { message: "Password cannot be blank." }, 
            length: { minimum: 6, message: "Password must be at least 6 characters long." },
            on: :create
  validate :password_complexity, 
            on: :create

  validates :email, 
            presence: { message: "E-mail cannot be blank." }, 
            uniqueness: { message: "This e-mail is already in use." }, 
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "Invalid e-mail." },
            on: :create

  validates :cpf, 
            presence: { message: "CPF cannot be blank." }, 
            uniqueness: { message: "This CPF is already in use." },
            on: :create
  validate :valid_cpf, 
            on: :create

  private

  def password_complexity
    return if password.blank? || password =~ /\A(?=.*[a-zA-Z])(?=.*[0-9])/
    errors.add(:password, 'The password must contain at least one letter and one number.')
  end

  def valid_cpf
    errors.add(:cpf, 'O cpf não é válido') unless CPF.valid?(cpf)
  end
end

