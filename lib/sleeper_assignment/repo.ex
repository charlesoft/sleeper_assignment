defmodule SleeperAssignment.Repo do
  use Ecto.Repo,
    otp_app: :sleeper_assignment,
    adapter: Ecto.Adapters.Postgres
end
