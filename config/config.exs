# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :watercooler,
  ecto_repos: [Watercooler.Repo]

# Configures the endpoint
config :watercooler, Watercooler.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "gYbqx3Dox+8Onay/MAbNJvkAf2qeQCTwRN5r1abGoWq5P7YG2L5fXZS22qFhIkZx",
  render_errors: [view: Watercooler.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Watercooler.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  issuer: "Watercooler",
  ttl: {30, :days},
  secret_key: "u8OgtM1kGkhqCwuhmap8utR8HWjthnyZ7Q7cW5KLtuuAhqqtViNdghTM9CBijr7d",
  serializer: Watercooler.GuardianSerializer

config :ueberauth, Ueberauth,
  providers: [
    facebook: {Ueberauth.Strategy.Facebook, []},
    github: {Ueberauth.Strategy.Github, []}
  ]

config :ueberauth, Ueberauth.Strategy.Facebook.OAuth,
  client_id: System.get_env("FACEBOOK_APP_ID"),
  client_secret: System.get_env("FACEBOOK_APP_SECRET"),
  redirect_uri: System.get_env("FACEBOOK_REDIRECT_URI")

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
