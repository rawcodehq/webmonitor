# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :webmonitor, Webmonitor.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "5ktGskuLVdAs5AhshtAEg2oJPevaZ5t/HzWbS3N6ra1yLEpC6iSm9ejzJNVP7PCW",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Webmonitor.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :webmonitor, ecto_repos: [Webmonitor.Repo]

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
  check_frequency_ms: 60_000,
  # email
  default_sender: {"Webmonitor Notification", "noreply@webmonitorhq.com"},
  # agents
  agents: ["http://localhost:8090"]

config :ex_aws,
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, :instance_role],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, :instance_role],
  region: "us-east-1"

# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
