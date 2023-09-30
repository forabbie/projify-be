require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  let(:user) { create(:user) }

  it 'logs in a user with valid credentials' do
    post '/api/v1/auth/signin',
    params: { 
      user: { 
        email: user.email,
        password: user.password
      } 
    }
    expect(response).to have_http_status(:success)
  end

  it 'does not log in a user with invalid credentials' do
    post '/api/v1/auth/signin',
    params: { 
      user: { 
        email: 'invalid@example.com', 
        password: 'wrongpassword' 
      } 
    }
    expect(response).to have_http_status(401) # Unauthorized
  end

  it 'logs out a user' do
    post '/api/v1/auth/signin',
    params: { 
      user: { 
        email: user.email,
        password: user.password
      } 
    }
    delete '/api/v1/auth/signout'

    expect(response).to have_http_status(200) # No Content
  end
end
