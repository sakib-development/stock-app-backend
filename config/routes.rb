Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get :fetch_stock_info, to: "stock#get_stock_info"
end
