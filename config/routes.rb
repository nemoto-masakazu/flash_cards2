Rails.application.routes.draw do

  get "quizzes/new" => "quizzes#new"
  get "quizzes/show" => "quizzes#show"
  get "quizzes/answer" => "quizzes#answer"
  get "quizzes/result" => "quizzes#result"

  get "sessions/login" => "sessions#new"
  post "sessions/login" => "sessions#create"
  get "sessions/logout" => "sessions#destroy"

  get "words/new_word" => "words#new"
  get "words/index" => "words#index"
  post "words/create" => "words#create"
  get "words/:id" => "words#show"
  get "words/:id/delete" => "words#destroy"
  patch "words/:id/update" => "words#update"
  get "words/:id/edit" => "words#edit"

  get "top" => "home#top"

  get "users/:id/delete" => "users#destroy"
  patch "users/:id/update" => "users#update"
  get "users/:id/edit" => "users#edit"
  get "users/index" => "users#index"
  get "users/:id" => "users#show"
  post "users/create" => "users#create"
  get "signup" => "users#new"

end
