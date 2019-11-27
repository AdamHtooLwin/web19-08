Rails.application.routes.draw do
  resources :messages
  resources :comments
  resources :user_groups
  resources :needs
  resources :groups
  resources :items
  get 'user_admin/index'
  patch 'user_admin/ban_user'

  get 'profile/show'
  get 'profile/edit'
  post 'profile/update_avatar'
  post 'profile/update'
  get 'registrations/new'
  get 'registrations/create'
  post 'registrations/create'
  get 'registrations/update'
  devise_for :users

  get 'documentation/index'
  get 'documentation/user_profiles'

  get 'basics/index'
  get 'ps2/index'
  get 'ps2/quotation'
  post 'ps2/quotation'
  post 'ps2/kill_quotation'
  post 'ps2/reset_kills'

  get 'ps1/index'
  get 'ps1/divide_by_zero'
  get 'ps1/scrapper'
  root 'site#index'
  get 'site/index'
  get 'ps2/export_json'
  get 'ps2/export_xml'
  post 'ps2/import_xml'
  get 'basics' => 'basics#index'
  get 'documentation' => 'documentation#index'
  get 'get_users' => 'groups#get_users'
  get 'add_users' => 'groups#add_users'
  post 'add_users' => 'groups#add_users'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
