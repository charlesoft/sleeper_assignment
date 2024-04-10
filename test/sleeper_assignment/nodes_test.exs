defmodule SleeperAssignment.NodesTest do
  use SleeperAssignment.DataCase

  import SleeperAssignment.Factory

  alias SleeperAssignment.{Node, Nodes, Repo}

  describe "nodes/1" do
    setup do
      cluster = insert!(:cluster)
      {:ok, cluster: cluster}
    end

    test "lists the nodes for the given cluster_id", %{cluster: %{id: cluster_id} = cluster} do
      %{id: node_one_id} = insert!(:node, status: :up, cluster: cluster)
      _node_two = insert!(:node, status: :up)
      %{id: node_three_id} = insert!(:node, status: :down, cluster: cluster)

      assert [%Node{id: ^node_one_id}, %Node{id: ^node_three_id}] =
               Nodes.nodes(%{"cluster_id" => cluster_id})
    end

    test "lists all nodes for the given cluster_id and network_partition_id", %{
      cluster: %{id: cluster_id} = cluster
    } do
      network_partition = insert!(:network_partition, cluster: cluster)

      %{id: node_one_id} =
        insert!(:node, status: :up, cluster: cluster, network_partition: network_partition)

      _node_two = insert!(:node, status: :up, cluster: cluster)
      _node_three = insert!(:node, status: :down, cluster: cluster)
      params = %{"cluster_id" => cluster_id, "network_partition_id" => network_partition.id}

      assert [%Node{id: ^node_one_id}] = Nodes.nodes(params)
    end
  end

  describe "get_node/1" do
    test "returns a node for the given id" do
      _node_one = insert!(:node)
      %{id: node_two_id} = insert!(:node)

      assert %Node{id: ^node_two_id} = Nodes.get_node(%{"id" => node_two_id})
    end
  end

  describe "get_node_by_port/1" do
    test "returns a node for the given server port" do
      %{id: node_one_id} = node = insert!(:node)
      _server = insert!(:server, node: node, port: 4_567)

      assert %Node{id: ^node_one_id} = Nodes.get_node_by_port(4_567)
    end
  end

  describe "update/2" do
    setup do
      cluster = insert!(:cluster)
      {:ok, cluster: cluster}
    end

    test "updates the node to type 'goose'",
         %{cluster: cluster} do
      %{id: node_id} = node = insert!(:node, status: :up, type: :duck, cluster: cluster)
      _server = insert!(:server, node: node)

      attrs = %{"type" => "goose"}

      assert {:ok, %Node{id: ^node_id, status: :up, type: :goose}} = Nodes.update(node, attrs)
    end

    test "does not update the node to type 'goose' if node is down",
         %{cluster: cluster} do
      node = insert!(:node, status: :down, type: :duck, cluster: cluster)
      _server = insert!(:server, node: node)

      attrs = %{"type" => "goose"}

      assert {:error,
              %Ecto.Changeset{
                errors: [status: {"can't have a node with type 'goose' and status 'down'", _}]
              }} = Nodes.update(node, attrs)
    end

    test "does not update the node to type 'goose' if there is already one",
         %{cluster: cluster} do
      node_one = insert!(:node, status: :up, type: :duck, cluster: cluster)
      _server = insert!(:server, node: node_one)

      node_two = insert!(:node, status: :up, type: :goose, cluster: cluster)
      _server = insert!(:server, node: node_two)

      attrs = %{"type" => "goose"}

      assert {:error,
              %Ecto.Changeset{errors: [type: {"must have only one node of type of 'goose'", _}]}} =
               Nodes.update(node_one, attrs)
    end

    test "does not update type to 'goose' if node is in a network partition and minimal quorum from the other side of the cluster is 3",
         %{cluster: %{id: cluster_id} = cluster} do
      network_partition = insert!(:network_partition, cluster: cluster)

      node_one =
        insert!(:node,
          status: :up,
          type: :duck,
          cluster: cluster,
          network_partition: network_partition
        )

      _node_two = insert!(:node, status: :up, type: :duck, cluster: cluster)
      _node_three = insert!(:node, status: :up, type: :duck, cluster: cluster)
      _node_four = insert!(:node, status: :up, type: :duck, cluster: cluster)

      attrs = %{"type" => "goose"}

      assert Nodes.update(node_one, attrs) ==
               {:error, "can't select a lost node as goose for cluster #{cluster_id}"}
    end

    test "updates type to 'goose' if node is in a network partition and minimal quorum from the other side of the cluster is not 3",
         %{cluster: cluster} do
      network_partition = insert!(:network_partition, cluster: cluster)

      %{id: node_one_id} =
        node_one =
        insert!(:node,
          status: :up,
          type: :duck,
          cluster: cluster,
          network_partition: network_partition
        )

      _server_one = insert!(:server, node: node_one)

      _node_two = insert!(:node, status: :up, type: :duck, cluster: cluster)
      _node_three = insert!(:node, status: :up, type: :duck, cluster: cluster)

      attrs = %{"type" => "goose"}

      assert {:ok, %Node{id: ^node_one_id, type: :goose}} = Nodes.update(node_one, attrs)
    end

    test "updates a node to be the new goose if current node goose is down", %{cluster: cluster} do
      %{id: node_one_id} = node_one = insert!(:node, status: :up, type: :duck, cluster: cluster)
      _server_onde = insert!(:server, node: node_one)

      node_two = insert!(:node, status: :up, type: :goose, cluster: cluster)
      _server_two = insert!(:server, node: node_two)

      attrs = %{"status" => "down"}

      assert {:ok,
              %Node{
                status: :down,
                type: :duck
              }} = Nodes.update(node_two, attrs)

      assert %Node{id: ^node_one_id, status: :up, type: :goose} = Repo.get!(Node, node_one_id)
    end

    test "does not update other node to type 'goose'if all nodes are down", %{cluster: cluster} do
      %{id: node_one_id} = node_one = insert!(:node, status: :down, type: :duck, cluster: cluster)
      _server_one = insert!(:server, node: node_one)

      %{id: node_two_id} = node_two = insert!(:node, status: :up, type: :goose, cluster: cluster)
      _server_two = insert!(:server, node: node_two)

      attrs = %{"status" => "down"}

      assert {:ok,
              %Node{
                id: ^node_two_id,
                status: :down,
                type: :duck
              }} = Nodes.update(node_two, attrs)

      assert %Node{id: ^node_one_id, status: :down, type: :duck} = Repo.get!(Node, node_one_id)
    end

    test "automatically reassigns a new node to be the 'goose' if current node is lost (network partition)",
         %{cluster: cluster} do
      node_one =
        insert!(:node,
          status: :up,
          type: :goose,
          cluster: cluster
        )

      _server_one = insert!(:server, node: node_one)

      %{id: node_two_id} = node_two = insert!(:node, status: :up, type: :duck, cluster: cluster)
      _server_two = insert!(:server, node: node_two)

      attrs = %{"status" => "lost"}

      assert {:ok,
              %Node{
                status: :down,
                type: :duck,
                network_partition_id: network_partition_id
              }} = Nodes.update(node_one, attrs)

      refute is_nil(network_partition_id)

      assert %Node{id: ^node_two_id, status: :up, type: :goose} = Repo.get!(Node, node_two_id)
    end
  end
end
