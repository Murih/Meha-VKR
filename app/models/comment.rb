class Comment < ApplicationRecord
  default_scope -> { order(created_at: :desc) }
  validates :content, presence: true, length: { maximum: 150 }
  belongs_to :micropost
  belongs_to :user

  self.per_page = 5
end