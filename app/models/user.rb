class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token
  before_save :email_downcase
  before_create :create_activation_digest

  scope :with_activated, -> {where activated: true}

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
            presence: true,
            length: {minimum: Settings.length.digit_6},
            allow_nil: true

  def self.digest string
    is_min_cost = ActiveModel::SecurePassword.min_cost
    cost = is_min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create string, cost: cost
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest

    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update_column :remember_digest, nil
  end

  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private

  def email_downcase
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
