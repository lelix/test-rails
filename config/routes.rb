Rails.application.routes.draw do
  get 'greetings/hello'

  root to: 'visitors#index'
end
