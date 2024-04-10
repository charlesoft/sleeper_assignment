defmodule SleeperAssignment.Factory do
  @moduledoc """
  Fatory for building the structs to be used in tests
  """
  alias SleeperAssignment.{
    Cluster,
    NetworkPartition,
    Node,
    Repo,
    Server
  }

  def insert!(factory_name, attributes \\ %{}) do
    factory_name
    |> build()
    |> struct!(attributes)
    |> Repo.insert!()
  end

  def build(:node) do
    %Node{
      type: :duck,
      status: :down,
      cluster: insert!(:cluster),
      network_partition_id: nil
    }
  end

  def build(:server) do
    %Server{port: 4_567, node: insert!(:node)}
  end

  def build(:network_partition) do
    %NetworkPartition{
      cluster: insert!(:cluster)
    }
  end

  def build(:cluster) do
    %Cluster{name: "Cluster Example"}
  end
end
