class User < ApplicationRecord
  before_save :email_downcase
  attr_accessor :remember_token

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

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    return false unless remember_digest

    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_column :remember_digest, nil
  end

  private

  def email_downcase
    email.downcase!
  end
end
