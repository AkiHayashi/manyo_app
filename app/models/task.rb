class Task < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :deadline_on, presence: true
  validates :priority, presence: true
  validates :status, presence: true

  enum priority: { '低': 0, '中': 1, '高': 2 }
  enum status: { '未着手': 0, '着手中': 1, '完了': 2 }
end
