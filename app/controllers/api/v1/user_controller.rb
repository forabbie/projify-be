class Api::V1::UserController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = User.all
  end

  def active_user
    render json: authenticated_user , status: :ok
  end
end
