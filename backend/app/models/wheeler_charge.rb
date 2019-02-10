class WheelerCharge < ApplicationRecord
  include VoltageClass

  belongs_to :district
end
