class Api::V1::UserController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def logged_user
    render json: authenticated_user , status: :ok
  end
end
