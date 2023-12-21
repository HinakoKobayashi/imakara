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

  devise_scope :user do
    post "users/guest_sign_in", to: "user/sessions#guest_sign_in"
  end

  get 'search', to: 'searches#index'
  #get '/tag/search' => 'searches#tag_search'

  namespace :admin do
    root to: 'homes#top'
    resources :users, only: [:index, :show, :edit, :update]
    resources :posts, only: [:index, :show, :destroy]
    resources :requests, omly: [:index, :show]
    resources :notifications, only: [:index, :update] do
    collection do
      patch :mark_all_as_read
    end
  end
  end

  scope module: :user do
    root to: 'homes#top'
    resources :users, only: [:index, :show, :edit, :update] do
      # :idを使用した特定のデータに対するアクションのためmemberを使用
      member do
        get :check
        patch :cancellation
      end
    end
    resources :posts do
      resource :favorite, only: [:create, :destroy]
      resources :comments, only: [:create, :edit, :update, :destroy]
      member do
        patch :update_draft
      end
    end
    resources :notifications, only: [:index, :update] do
      collection do
        patch :mark_all_as_read
      end
    end
    resources :requests, only: [:new, :create]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
