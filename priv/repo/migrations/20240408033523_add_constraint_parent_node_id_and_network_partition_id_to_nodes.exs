defmodule SleeperAssignment.Repo.Migrations.AddConstraintParentNodeIdAndNetworkPartitionIdToNodes do
  use Ecto.Migration

  def change do
    create constraint(
      :nodes,
      :parent_node_id_only_for_and_network_partition_id_nil,
      check: "(parent_node_id IS NOT NULL AND network_partition_id IS NULL) OR
              (parent_node_id IS NULL AND network_partition_id IS NOT NULL) OR
              (parent_node_id IS NULL AND network_partition_id IS NULL)"
    )
  end
end
