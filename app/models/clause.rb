class Clause < ActiveRecord::Base

  include RankedModel

  validates :text, presence: true
  validates :no, presence: true

  ranks :no, with_same: :crossheading_id

  belongs_to :crossheading

end
