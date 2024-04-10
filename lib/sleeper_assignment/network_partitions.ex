defmodule SleeperAssignment.NetworkPartitions do
  @moduledoc """
  NetworkPartitions contex
  """

  alias SleeperAssignment.{NetworkPartition, Repo}

  def create_network_partition(attrs) do
    %NetworkPartition{}
    |> NetworkPartition.changeset(attrs)
    |> Repo.insert()
  end
end