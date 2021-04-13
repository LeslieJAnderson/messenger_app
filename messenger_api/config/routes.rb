Rails.application.routes.draw do
  resource :user, only: [:create]
  resource :message, only: [:create] do
    match 'recent/:num_days/days/from/:from_username/to/:to_username' => 'messages#recent_days', :via => :get
    match 'recent/:num_messages/messages/from/:from_username/to/:to_username' => 'messages#recent_count', :via => :get
    match 'recent/:num_days/days/from/everyone' => 'messages#recent_everyone_days', :via => :get
    match 'recent/:num_messages/messages/from/everyone' => 'messages#recent_everyone_count', :via => :get
  end
end
