defmodule SleeperAssignment.Nodes do
  @moduledoc """
  Nodes context
  """
  alias SleeperAssignment.{Repo, NetworkPartition, Node, Server}

  import Ecto.Query

  def nodes(params) do
    Node
    |> apply_filters(params)
    |> preload([:server])
    |> Repo.all()
  end

  def get_node(params) do
    Node
    |> apply_filters(params)
    |> limit(1)
    |> Repo.one()
  end

  defp apply_filters(query, params) do
    Enum.reduce(params, query, fn {key, value}, acc ->
      filter_by(acc, %{key => value})
    end)
  end

  defp filter_by(query, %{"id" => id}) do
    where(query, [n], n.id == ^id)
  end

  defp filter_by(query, %{"cluster_id" => cluster_id}) do
    where(query, [n], n.cluster_id == ^cluster_id)
  end

  defp filter_by(query, %{"type" => type}) do
    where(query, [n], n.type == ^type)
  end

  defp filter_by(query, %{"status" => status}) do
    where(query, [n], n.status == ^status)
  end

  defp filter_by(query, %{"network_partition_id" => network_partition_id}) do
    where(query, [n], n.network_partition_id == ^network_partition_id)
  end

  defp filter_by(query, %{}), do: query

  def get_node_by_port(port) do
    Node
    |> join(:inner, [n], s in assoc(n, :server))
    |> where([n, s], s.port == ^port)
    |> Repo.one()
  end

  def update(%Node{} = node, attrs) do
    attrs =
      if Map.get(attrs, "status") == "lost" do
        {:ok, network_partition} = create_network_partition(node)

        attrs
        |> Map.delete("status")
        |> Map.put("network_partition_id", network_partition.id)
      else
        attrs
      end

    with changeset <- Node.changeset(node, attrs),
         :ok <- ensure_change_type(attrs, node),
         {:ok, node} <- Repo.update(changeset) do
      update_new_goose_for_cluster(changeset, node)
      update_server_status(node)

      {:ok, node}
    end
  end

  defp create_network_partition(node) do
    %NetworkPartition{cluster_id: node.cluster_id}
    |> Repo.insert()
  end

  defp ensure_change_type(%{"type" => "goose"}, %Node{network_partition_id: nil}) do
    :ok
  end

  defp ensure_change_type(%{"type" => "goose"}, %Node{cluster_id: cluster_id}) do
    minimal_number_for_quorum = 3

    count_nodes_with_no_network_partition =
      Node
      |> where([n], n.cluster_id == ^cluster_id)
      |> where([n], is_nil(n.network_partition_id))
      |> Repo.aggregate(:count)

    if count_nodes_with_no_network_partition >= minimal_number_for_quorum do
      {:error, "can't select a lost node as goose for cluster #{cluster_id}"}
    else
      :ok
    end
  end

  defp ensure_change_type(_attrs, _node), do: :ok

  defp update_new_goose_for_cluster(
         %Ecto.Changeset{changes: %{status: :down, type: :duck}},
         %Node{id: node_id, cluster_id: cluster_id} = _current_node
       ) do
    params = %{"cluster_id" => cluster_id, "status" => "up"}

    Node
    |> apply_filters(params)
    |> where([n], n.id != ^node_id)
    |> Repo.all()
    |> case do
      [] ->
        {:ok, nil}

      nodes ->
        if node = Enum.find(nodes, fn node -> is_nil(node.network_partition_id) end) do
          node
        else
          List.first(nodes)
        end

        update_type(node, "goose")
    end
  end

  defp update_new_goose_for_cluster(_changeset, _node), do: {:ok, nil}

  defp update_type(node, type) do
    node
    |> Node.changeset(%{"type" => type})
    |> Repo.update()
  end

  defp update_server_status(%Node{status: status} = node) do
    node = Repo.preload(node, :server)

    node.server
    |> Server.changeset(%{status: status})
    |> Repo.update()
  end

  defp update_server_status(_node), do: {:ok, nil}
end
