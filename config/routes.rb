Rails.application.routes.draw do
  namespace :admin do
    get 'users/index'
    get 'users/show'
    get 'users/edit'
  end
  namespace :admin do
    get 'requests/index'
    get 'requests/show'
  end
  namespace :admin do
    get 'posts/index'
    get 'posts/show'
  end
  namespace :user do
    get 'notifications/index'
  end
  namespace :user do
    get 'posts/new'
    get 'posts/index'
    get 'posts/show'
    get 'posts/edit'
  end
  namespace :user do
    get 'users/index'
    get 'users/show'
    get 'users/edit'
    get 'users/check'
  end
  namespace :user do
    get 'requests/new'
  end
  namespace :user do
    get 'homes/top'
  end
  devise_for :admins, skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
}

  devise_for :users, skip: [:passwords], controllers: {
  registrations: "user/registrations",
  sessions: 'user/sessions'
}
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
