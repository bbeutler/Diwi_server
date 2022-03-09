# This model is the basis for the "friends" or "Who was there".
# Renaming this class and all associated logic was not realistic.
class Tag < ApplicationRecord
  update_index('tags#tag') { self }

  belongs_to :consumer

  has_many :look_tags, dependent: :destroy
  has_many :looks, through: :look_tags

  validates :title, :consumer, presence: true
  validates_uniqueness_of :title, scope: :consumer_id, case_sensitive: false # Only validate uniqueness from consumer's list of friends
end
