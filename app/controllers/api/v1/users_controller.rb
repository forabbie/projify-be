class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = User.all
    render json: {
      status: { code: 200, message: 'Users retrieve successfully.' },
      data: @user.map { |user| UserSerializer.new(user).serializable_hash[:data][:attributes] }
    }
  end

  def active_user
    render json: {
      status: { code: 200, message: 'User retrieve successfully.' },
      data: UserSerializer.new( active_session ).serializable_hash[:data][:attributes]
    }
  end
end
