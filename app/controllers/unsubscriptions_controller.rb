class UnsubscriptionsController < ApplicationController
  before_action :delivery_data

  def new
    @delivery_id = uuid
    @customer = Customer
      .where(uuid: delivery_data[:customer_uuid])
      .first
  end

  def create
    service.unsubscribe!
  end

  private

  def delivery_data
    @delivery_data ||= service.delivery_data
  end

  def service
    @service ||= UnsubscriptionsService.new(uuid, request)
  end

  def uuid
    params[:unsubscriptions][:uuid]
  end
end
