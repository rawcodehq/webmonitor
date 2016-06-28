defmodule Webmonitor.Router do
  use Webmonitor.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Webmonitor.LoadUser
  end

  pipeline :authenticated do
    plug Webmonitor.AuthenticateUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # public routes
  scope "/", Webmonitor do
    pipe_through :browser # Use the default browser stack

    get "/", MonitorController, :index
    resources "/registration", RegistrationController, only: [:new, :create], singleton: true
    resources "/session", SessionController, only: [:new, :create, :delete], singleton: true
  end

  # authenticated routes
  scope "/", Webmonitor do
    pipe_through [:browser, :authenticated] # Use the default browser stack

    resources "/monitors", MonitorController
    get "/monitors/:id/check", MonitorController, :check
  end

  # Other scopes may use custom stacks.
  # scope "/api", Webmonitor do
  #   pipe_through :api
  # end

  # dev stuff
  if Mix.env == :dev do
    # to view sent emails on the current server using the local adapter
    forward "/sent_emails", Bamboo.EmailPreviewPlug
  end
end
