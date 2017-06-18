RedmineApp::Application.routes.draw do

  resources :projects do
    resources :issues_trees, only: :none do
      collection do
        get 'tree_index'
        post 'redirect_with_params'
      end

      member do
        get 'tree_children'
      end
    end
  end

  resources :issues_trees, only: :none do
    collection do
      get 'tree_index'
      post 'redirect_with_params'
    end

    member do
      get 'tree_children'
    end
  end

end
