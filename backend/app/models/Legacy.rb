class Legacy < ActiveRecord::Base
  self.abstract_class = true
  self.establish_connection(:legacy)
end
