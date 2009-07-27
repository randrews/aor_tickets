ActionController::Routing::Routes.draw do |map|

  map.resources :tickets

  map.root :controller=>'ticket', :action=>'index'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
