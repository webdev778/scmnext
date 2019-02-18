class BgMembersController < ApplicationController
  include SimpleRestApi

  protected

  def filter_for_all(relation)
    relation.where(balancing_group_id: params[:balancing_group_id])
  end
end
