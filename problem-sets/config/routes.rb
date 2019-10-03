Rails.application.routes.draw do
  get 'ps2/index'
  get 'ps2/quotation'
  post 'ps2/quotation'

  get 'ps1/index'
  get 'ps1/divide_by_zero'
  get 'ps1/scrapper'
  root 'site#index'
  get 'site/index'

  get 'basics' => 'ps1#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
