Rails.application.routes.draw do
    
  resources :novelties

  resources :faqs

  get 'index/update'

  resources :quizzes
  #resources :users

  root 'static_pages#home'

  get 'static_pages/home'
  get 'static_pages/faq'
  get 'static_pages/about'
  get 'static_pages/contact'
  get 'static_pages/news'
  get 'static_pages/quiz'
  get 'static_pages/profile_status'
  get 'static_pages/profile_data'
  get 'static_pages/admin'
  get 'static_pages/payment'
  post 'static_pages/pay'


  devise_for :users, :controllers => { registrations: 'registrations' }

  get 'users/index'
  get 'users/update'
  get 'users/edit_admin'
  get 'users/edit_password'
  get 'users/edit_email'
  patch 'users/update'
    
    
  resource :user, only: [:edit_admin] do
    collection do
      patch 'update_admin'
    end
  end  
    
  resource :user, only: [:edit_password] do
    collection do
      patch 'update_password'
    end
  end
  
  resource :user, only: [:edit_email] do
    collection do
      patch 'update_email'
    end
  end
  
  mathjax 'mathjax'
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
