defmodule SleeperAssignment.Cluster do
  @moduledoc """
  Cluster model
  """
  use Ecto.Schema

  import Ecto.Changeset

  schema "clusters" do
    field :name, :string

    timestamps()
  end

  def changeset(cluster, attrs) do
    cluster
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end