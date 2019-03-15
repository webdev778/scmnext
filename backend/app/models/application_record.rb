class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  class << self
    def logger
      Rails.logger
    end
  end

  def logger
    Rails.logger
  end
end
