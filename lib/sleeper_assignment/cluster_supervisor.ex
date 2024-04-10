defmodule SleeperAssignment.ClusterSupervisor do
  use Supervisor

  alias SleeperAssignment.{Nodes, NodeServer}

  def start_link(cluster) do
    IO.puts("Starting cluster Supervisor")

    Supervisor.start_link(__MODULE__, cluster, name: __MODULE__)
  end

  def init(cluster) do
    nodes = Nodes.list_nodes(%{"cluster_id" => cluster.id})

    children = Enum.map(nodes, fn node ->
      %{
        id: "NodeServer_#{node.id}",
        start: {NodeServer, :start_link, [node]}
      }
    end)

    Supervisor.init(children, strategy: :one_for_one)
  end
end