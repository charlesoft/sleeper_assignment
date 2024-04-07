defmodule SleeperAssignment.Repo.Migrations.CreateTableHttpServers do
  use Ecto.Migration

  def change do
    create table(:servers) do
      add :port, :integer, null: false
      add :type, :string, default: "http", null: false
      add :status, :string, default: "down", null: false

      add :node_id, references(:nodes, on_delete: :delete_all)

      timestamps()
    end
  end
end
