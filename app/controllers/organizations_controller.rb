class OrganizationsController < ApplicationController
  def show
    render json: Organization.all
  end
end