class LinksController < ApplicationController
  def show
    redirect_to LinkClickService.new(params[:id], request).destination
  end
end
