class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_secure_password

  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum: 255 }, uniqueness: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :password, presence: true, length: { minimum: 6 }

  before_validation { email.downcase! }
  before_update :admin_cannot_update_if_last_one
  before_destroy :admin_cannot_delete_if_last_one

  private

  def admin_cannot_update_if_last_one
    throw :abort, errors.add(:base, '管理者が0人になるため権限を変更できません')  if User.where(admin: true).count == 1 && self.will_save_change_to_admin?(from: true, to: false)
  end

  def admin_cannot_delete_if_last_one
    throw :abort if User.where(admin: true).count == 1 && self.admin == true
  end
end
