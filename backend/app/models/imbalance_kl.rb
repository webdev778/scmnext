class ImbalanceKl < ApplicationRecord
  belongs_to :district

  scope :includes_for_index, lambda {
    includes(:district)
  }

  validates :k_value,
    numericality: {presence: true}

  validates :l_value,
    numericality: {presence: true}

  def as_json(options = {})
    if options.blank?
      options = {
        include: :district
      }
    end
    super options
  end
end
