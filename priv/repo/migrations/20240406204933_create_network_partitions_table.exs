defmodule SleeperAssignment.Repo.Migrations.CreateNetworkPartitionsTable do
  use Ecto.Migration

  def change do
    create table(:network_partitions) do
      add :cluster_id, references(:clusters, on_delete: :delete_all)

      timestamps()
    end
  end
end
