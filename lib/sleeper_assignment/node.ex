defmodule SleeperAssignment.Node do
  @moduledoc """
  Node model
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias SleeperAssignment.{Cluster, NetworkPartition, Node, Server}

  @node_types [:duck, :goose]
  @node_status [:up, :down]

  schema "nodes" do
    field :type, Ecto.Enum, values: @node_types, default: :duck
    field :status, Ecto.Enum, values: @node_status, default: :up

    belongs_to :cluster, Cluster
    belongs_to :network_partition, NetworkPartition

    has_one :server, Server

    timestamps()
  end

  def changeset(node, attrs) do
    node
    |> cast(attrs, [:type, :status, :cluster_id, :network_partition_id])
    |> validate_required([:type, :status, :cluster_id])
    |> validate_type_and_status()
    |> validate_network_partition_and_status()
    |> unique_constraint([:type, :cluster_id],
      name: :unique_cluster_id_and_type_goose,
      message: "must have only one node of type of 'goose'"
    )
    |> check_constraint(:type,
      name: :type_and_status,
      message: "can't have a node with type 'goose' and status 'down'"
    )
  end

  def validate_type_and_status(%Ecto.Changeset{changes: %{status: :down}} = changeset) do
    if get_field(changeset, :type) == :goose do
      change(changeset, type: :duck)
    else
      changeset
    end
  end

  def validate_type_and_status(%Ecto.Changeset{changes: %{type: :goose}} = changeset) do
    if get_field(changeset, :status) == :down do
      add_error(changeset, :status, "can't have a node with type 'goose' and status 'down'")
    else
      changeset
    end
  end

  def validate_type_and_status(changeset), do: changeset


  def validate_network_partition_and_status(%Ecto.Changeset{changes: %{network_partition_id: network_partition_id}} = changeset) do
    if network_partition_id do
      changeset
      |> change(type: :duck)
      |> change(status: :down)
    else
      changeset
    end
  end

  def validate_network_partition_and_status(changeset), do: changeset
end
