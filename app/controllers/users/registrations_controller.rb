# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionsFix
  respond_to :json

  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
  
  private
  def respond_with(resource, _opts = {})
    return render_user_creation_error(resource) unless resource.persisted?
  
    workspace = Workspace.new(name: "Main Workspace", user: resource)
  
    if workspace.save
      user_workspace = UserWorkspace.create(workspace: workspace, user: resource, role: "admin")
      return render_user_creation_error(resource) unless user_workspace.save
  
      render json: {
        status: { code: 200, message: 'Signed up successfully.' },
        data: {
          user: UserSerializer.new(resource).serializable_hash[:data][:attributes],
          workspace: { id: workspace.id }
        }
      }
    else
      render_workspace_creation_error(resource)
    end
  end
  
  def render_user_creation_error(resource)
    resource.destroy
    render json: {
      status: { message: 'Failed to create user workspace association.' },
      errors: resource.errors.full_messages
    }, status: :unprocessable_entity
  end
  
  def render_workspace_creation_error(resource)
    resource.destroy
    render json: {
      status: { message: 'Failed to create a new workspace.' }
    }, status: :unprocessable_entity
  end
  

end
