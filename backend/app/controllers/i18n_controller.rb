class I18nController < ApplicationController
  def show
  	render json: I18n.translate('activerecord.attributes')
  end
end
