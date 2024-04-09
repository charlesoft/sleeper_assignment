defmodule SleeperAssignment.Repo.Migrations.AddConstraintToTypeAndStatusToNodes do
  use Ecto.Migration

  def change do
    create constraint(
      :nodes,
      :type_and_status,
      check: "(type = 'goose' AND status = 'up') OR type = 'duck'"
    )
  end
end
