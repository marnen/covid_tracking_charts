Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'welcome#main'
  resources :states, param: :states do
    post :choose, on: :collection
  end
end
