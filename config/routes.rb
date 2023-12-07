Rails.application.routes.draw do

  namespace :admin do
    get 'notifications/index'
  end
  namespace :admin do
    get 'homes/top'
  end
  devise_for :admins, skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
}

  devise_for :users, skip: [:passwords], controllers: {
  registrations: "user/registrations",
  sessions: 'user/sessions'
}

  get '/search' => 'searches#search'
  get '/tag/search' => 'searches#tag_search'

  namespace :admin do
    root to: 'homes#top'
    resources :users, only: [:index, :show, :edit, :update]
    resources :posts, only: [:index, :show, :destroy]
    resources :requests, omly: [:index, :show]
  end

  scope module: :user do
    root to: 'homes#top'
    resources :users, only: [:index, :show, :edit, :update] do
      resources :notifications, only: [:index, :destroy]
      # :idを使用した特定のデータに対するアクションのためmemberを使用
      member do
        get :favorites
        get :check
        patch :cancellation
      end
    end
    resources :posts do
      resource :favorite, only: [:create, :destroy]
      resources :comments, only: [:create, :edit, :update, :destroy]
    end
    resources :requests, only: [:new, :create]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
