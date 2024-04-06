defmodule SleeperAssignment.Node do
  @moduledoc """
  Node model
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias SleeperAssignment.{Cluster, NetworkPartition, Node}

  @node_types [:duck, :goose]
  @node_status [:up, :down]

  schema "nodes" do
    field :type, Ecto.Enum, values: @node_types, default: :duck
    field :status, Ecto.Enum, values: @node_status, default: :up

    belongs_to :cluster, Cluster
    belongs_to :child_node, Node
    belongs_to :network_partition, NetworkPartition

    has_one :node, Node

    timestamps()
  end

  def changeset(node, attrs) do
    node
    |> cast(attrs, [:type, :status, :cluster_id, :node_id, :network_partition_id])
    |> validate_required([:type, :status, :cluster_id, :node_id, :network_partition_id])
  end
end