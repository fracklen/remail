class LinksController < ApplicationController
  def show
    redirect_to LinkClickService.new(params[:id], params).destination
  end
end
