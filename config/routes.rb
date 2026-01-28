Rails.application.routes.draw do
  root to: "pages#landing"

  resources :users do
    get "library", to: "library#index"
  end
  resources :user_books, only: [ :create, :update, :destroy ]
  resources :books, only: [ :index, :show ] do
    collection do
      get :search
    end
  end
  resource :session
  resources :passwords, param: :token
  # This is a blank app! Pick your first screen, build out the RCAV, and go from there. E.g.:
  # get("/your_first_screen", { :controller => "pages", :action => "first" })
end
