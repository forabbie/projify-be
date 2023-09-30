require 'rails_helper'

RSpec.describe 'Registrations', type: :request do

  it 'creates a new user with valid attributes' do
    post '/api/v1/signup', 
    params: { 
      user: { 
        email: 'new@example.com', 
        password: 'password123' 
      } 
    }
    expect(response).to have_http_status(:success)
  end

  it 'does not create a new user with invalid attributes' do
    post '/api/v1/signup', 
    params: { 
      user: { 
        email: '', 
        password: 'short' 
      } 
    }
    expect(response).to have_http_status(422) # Unprocessable Entity
  end
end
