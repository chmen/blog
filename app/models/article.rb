class Article < ActiveRecord::Base
  has_many :comments
  validates :title, presence: true, length: { minimum: 5}
  validates :status, presence: true, inclusion: { in: (0..5) }
end
