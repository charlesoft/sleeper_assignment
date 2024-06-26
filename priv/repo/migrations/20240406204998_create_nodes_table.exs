defmodule SleeperAssignment.Repo.Migrations.CreateNodesTable do
  use Ecto.Migration

  def change do
    create table(:nodes) do
      add :type, :string, default: "duck", null: false
      add :status, :string, default: "up", null: false
      add :cluster_id, references(:clusters, on_delete: :delete_all), null: false
      add :network_partition_id, references(:network_partitions, on_delete: :delete_all)

      timestamps()
    end
  end
end
