Rails.application.routes.draw do
  resources :saml, only: :index do
    collection do
      get :sso
      post :acs
      get :metadata
      get :logout
    end
  end

  root 'saml#index'
end
