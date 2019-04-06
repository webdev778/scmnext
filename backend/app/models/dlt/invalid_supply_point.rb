class Dlt::InvalidSupplyPoint < ApplicationRecord
  # don't use this relation.
  # belongs_to :company
  # belongs_to :district
  belongs_to :bg_member

  scope :includes_for_index, lambda {
    includes(bg_member: [:company, {balancing_group: :district}])
  }

  def as_json(options = {})
    if options.blank?
      options = {
        include: {
          bg_member: {
            include:
              [
                :company,
                {
                  balancing_group: {
                    include: :district
                  }
                }
              ]
          }
        }
      }
    end
    super options
  end

end
