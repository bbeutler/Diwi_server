class Look < ApplicationRecord
  update_index('looks#look') { self }
  belongs_to :consumer

  has_many :look_tags, dependent: :destroy
  has_many :tags, through: :look_tags

  has_many :photos, dependent: :destroy

  has_many :videos, dependent: :destroy

  validates :title, :dates_worn, presence: true

  
end
