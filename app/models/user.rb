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

  def self.digest string
    is_min_cost = ActiveModel::SecurePassword.min_cost
    cost = is_min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  private

  def email_downcase
    email.downcase!
  end
end
