defmodule SleeperAssignment.ClusterSupervisorTest do
  use SleeperAssignment.DataCase

  alias SleeperAssignment.{ClusterSupervisor, Repo}

  import SleeperAssignment.Factory

  setup do
    cluster = insert!(:cluster)

    {:ok, cluster: cluster}
  end

  test "starts cluster and its nodes", %{cluster: cluster} do
    insert!(:node, cluster: cluster)
    insert!(:node, cluster: cluster)
    insert!(:node, cluster: cluster)

    {:ok, _} = ClusterSupervisor.start_link(cluster)

    assert [
      {_node_one, pid_1, :worker, [SleeperAssignment.NodeServer]},
      {_node_two, pid_2, :worker, [SleeperAssignment.NodeServer]},
      {_node_three, pid_3, :worker, [SleeperAssignment.NodeServer]},
    ] = Supervisor.which_children(ClusterSupervisor)

    assert Process.alive?(pid_1)
    assert Process.alive?(pid_2)
    assert Process.alive?(pid_3)
  end
end