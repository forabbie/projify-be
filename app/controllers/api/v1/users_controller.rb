class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = User.all
  end

  def active_user
    render json: active_session , status: :ok
  end
end
