defmodule SleeperAssignment.HttpServer do
  @moduledoc """
  HttpServer model
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias SleeperAssignment.{Node}

  @http_server_status [:up, :down]

  schema "http_servers" do
    field :url, :string
    field :status, Ecto.Enum, values: @http_server_status, default: :up

    belongs_to :node, Node

    timestamps()
  end

  def changeset(http_server, attrs) do
    http_server
    |> cast(attrs, [:url, :status, :node_id])
    |> validate_required([:url, :status, :node_id])
  end
end