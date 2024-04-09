defmodule SleeperAssignment.Server do
  @moduledoc """
  Server model
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias SleeperAssignment.{Node}

  @server_status [:up, :down]

  schema "servers" do
    field :port, :integer
    field :type, :string
    field :status, Ecto.Enum, values: @server_status, default: :down

    belongs_to :node, Node

    timestamps()
  end

  def changeset(server, attrs) do
    server
    |> cast(attrs, [:port, :type, :status, :node_id])
    |> validate_required([:port, :type, :status, :node_id])
  end
end
