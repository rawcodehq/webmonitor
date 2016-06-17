defmodule Webmonitor.Router do
  use Webmonitor.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Webmonitor do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/registration", RegistrationController, only: [:new, :create], singleton: true
  end

  # Other scopes may use custom stacks.
  # scope "/api", Webmonitor do
  #   pipe_through :api
  # end
end
