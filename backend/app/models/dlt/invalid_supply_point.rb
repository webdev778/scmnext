class Dlt::InvalidSupplyPoint < ApplicationRecord
  belongs_to :company
  belongs_to :district

  scope :includes_for_index, lambda {
    includes([:company, :district])
  }

  def as_json(options = {})
    if options.blank?
      options = {
        include: [:company, :district]
      }
    end
    super options
  end

end
