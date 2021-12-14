class User < ApplicationRecord
  before_save :email_downcase

  validates :name,
            presence: true,
            length: {maximum: Settings.length.digit_50}

  validates :email,
            presence: true,
            length: {maximum: Settings.length.digit_255},
            format: {with: Settings.pattern.valid_email},
            uniqueness: true

  has_secure_password

  validates :password,
            length: {minimum: Settings.length.digit_6}

  private
  def email_downcase
    email.downcase!
  end
end
