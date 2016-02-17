class AdminController < ApplicationController
  before_filter :authenticate_administrator!
  before_action :cluster_health

  private

  helper_method :cluster_health
  def cluster_health
    @cluster_health ||= ElasticStatusService.new.status
  end
end
