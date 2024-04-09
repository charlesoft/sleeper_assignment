defmodule SleeperAssignment.NetworkPartition do
  @moduledoc """
  NetworkPartition model
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias SleeperAssignment.{Cluster, Node}

  schema "network_partitions" do
    belongs_to :cluster, Cluster

    has_one :nodes, Node

    timestamps()
  end

  def changeset(network_partition, attrs) do
    network_partition
    |> cast(attrs, [:cluster_id])
    |> validate_required([:cluster_id])
  end
end
