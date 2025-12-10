Rails.application.routes.draw do
  root to: "pages#landing"
  resources :user_books
  resources :books
  resource :session
  resources :passwords, param: :token
  # This is a blank app! Pick your first screen, build out the RCAV, and go from there. E.g.:
  # get("/your_first_screen", { :controller => "pages", :action => "first" })

end
