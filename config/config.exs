# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :webmonitor, Webmonitor.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "5ktGskuLVdAs5AhshtAEg2oJPevaZ5t/HzWbS3N6ra1yLEpC6iSm9ejzJNVP7PCW",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Webmonitor.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

# email config
config :webmonitor, Webmonitor.Mailer,
  adapter: Bamboo.LocalAdapter

config :webmonitor,
  # email
  default_sender: "Webmonitor Notification <noreply@webmonitor.com>"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
