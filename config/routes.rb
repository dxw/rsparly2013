Rsparly2013::Application.routes.draw do

  resources :legislations, path: '/', only: [:index, :show] do
  end

  resources :debates
end
