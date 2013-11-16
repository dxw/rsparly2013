Rsparly2013::Application.routes.draw do

  resources :legislation, path: '/', only: [:index, :show] do
  end

end
