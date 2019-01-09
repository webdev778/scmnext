class Legacy::Converter < ActiveRecord::Base
  self.establish_connection(:legacy)
end
