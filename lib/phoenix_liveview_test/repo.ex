defmodule PhoenixLiveviewTest.Repo do
  use Ecto.Repo,
    otp_app: :phoenix_liveview_test,
    adapter: Ecto.Adapters.SQLite3
end
