# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :chattr,
  ecto_repos: [Chattr.Repo]

# Configures the endpoint
config :chattr, ChattrWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "m3Rp3KgtcPH0J2vad2Z3S0jFdYU9JlxaDaKrdlCOGUTi/1VZFQiZ0eiZDjuE2A/d",
  render_errors: [view: ChattrWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Chattr.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
