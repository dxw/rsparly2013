class Legislation < ActiveRecord::Base

  validates :title,     presence: true
  validates :passed_on, presence: true

  has_many :crossheadings, dependent: :destroy
  has_many :clauses, through: :crossheadings

end
