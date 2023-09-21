Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: '/auth/signin',
    sign_out: '/auth/signout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
end
