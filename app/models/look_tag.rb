class LookTag < ApplicationRecord
  belongs_to :tag
  belongs_to :look

  validates :tag, :look, presence: true
end
