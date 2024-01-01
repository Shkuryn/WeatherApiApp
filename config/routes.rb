# frozen_string_literal: true

Rails.application.routes.draw do
  # get '/health', to: 'weather#health'
  mount API::Root => '/'
end
