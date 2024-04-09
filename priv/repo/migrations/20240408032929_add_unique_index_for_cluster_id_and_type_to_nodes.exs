defmodule SleeperAssignment.Repo.Migrations.AddUniqueIndexForClusterIdAndTypeToNodes do
  use Ecto.Migration

  def change do
    create unique_index(:nodes, [:cluster_id, :type],
             where: "type = 'goose'",
             name: "unique_cluster_id_and_type_goose"
           )
  end
end
