class Crossheading < ActiveRecord::Base

  include RankedModel

  validates :title, presence: true
  validates :no, presence: true

  ranks :no, with_same: :legislation_id

  belongs_to :legislation
  has_many :clauses, dependent: :destroy

end
