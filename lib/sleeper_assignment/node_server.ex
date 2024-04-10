defmodule SleeperAssignment.NodeServer do
  use GenServer

  alias SleeperAssignment.HttpServer
  alias SleeperAssignment.Nodes

  def start_link(node) do
    IO.puts("Starting node server for Node #{node.id}...")
    name = String.to_atom("node_#{node.id}")

    IO.inspect(name, label: "Node Name")

    GenServer.start_link(__MODULE__, node, name: name)
  end

  def init(node) do
    send(self(), :start_server)

    {:ok, node}
  end

  def handle_info(:start_server, node) do
    Nodes.update(node, %{status: :up})

    # Start HTTP Server
    HttpServer.start(node.server.port)

    {:noreply, node}
  end
end