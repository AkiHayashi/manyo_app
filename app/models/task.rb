class Task < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :content, presence: true
  validates :deadline_on, presence: true
  validates :priority, presence: true
  validates :status, presence: true

  enum priority: { '低': 0, '中': 1, '高': 2 }
  enum status: { '未着手': 0, '着手中': 1, '完了': 2 }

  scope :search_by_title, -> (title) { where("title LIKE ?", "%#{title}%") }
  scope :search_by_status, -> (status) { where(status: status) }
  scope :order_by_deadline_on, -> { order(deadline_on: :asc) }
  scope :order_by_priority, -> { order(priority: :desc) }
  scope :order_by_created_at, -> { order(created_at: :desc) }
  # Ex:- scope :active, -> {where(:active => true)}
end
