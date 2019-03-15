class Legacy < ApplicationRecord
  self.abstract_class = true
  establish_connection(:legacy)
end
