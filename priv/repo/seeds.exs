alias SleeperAssignment.Repo
alias SleeperAssignment.{Cluster, Node, NetworkPartition, Server}

# Create clusters
cluster_one = Repo.insert!(%Cluster{name: "Cluster 1"})
cluster_two = Repo.insert!(%Cluster{name: "Cluster 2"})

# Create network partitions for cluster one
network_partition_one = Repo.insert!(%NetworkPartition{cluster_id: cluster_one.id})
network_partition_two = Repo.insert!(%NetworkPartition{cluster_id: cluster_one.id})

# Create network partitions for cluster two
network_partition_three = Repo.insert!(%NetworkPartition{cluster_id: cluster_two.id})

# Create nodes for cluster one
node_one =
  Repo.insert!(%Node{
    type: :duck,
    status: :down,
    cluster_id: cluster_one.id,
    network_partition_id: network_partition_one.id
  })

_server_one = Repo.insert!(%Server{port: Enum.random(4_000..10_000), node_id: node_one.id})

node_two =
  Repo.insert!(%Node{
    type: :duck,
    status: :down,
    cluster_id: cluster_one.id,
    network_partition_id: network_partition_two.id
  })

_server_two = Repo.insert!(%Server{port: Enum.random(4_000..10_000), node_id: node_two.id})

node_three =
  Repo.insert!(%Node{
    type: :duck,
    status: :down,
    cluster_id: cluster_one.id
  })

_server_three = Repo.insert!(%Server{port: Enum.random(4_000..10_000), node_id: node_three.id})

node_four =
  Repo.insert!(%Node{
    type: :duck,
    status: :down,
    cluster_id: cluster_one.id,
    parent_node_id: node_three.id
  })

_server_four = Repo.insert!(%Server{port: Enum.random(4_000..10_000), node_id: node_four.id})

node_five =
  Repo.insert!(%Node{
    type: :duck,
    status: :down,
    cluster_id: cluster_one.id,
    parent_node_id: node_four.id
  })

_server_five = Repo.insert!(%Server{port: Enum.random(4_000..10_000), node_id: node_five.id})

node_six =
  Repo.insert!(%Node{
    type: :duck,
    status: :down,
    cluster_id: cluster_one.id,
    parent_node_id: node_five.id
  })

_server_six = Repo.insert!(%Server{port: Enum.random(4_000..10_000), node_id: node_six.id})

node_seven =
  Repo.insert!(%Node{
    type: :duck,
    status: :down,
    cluster_id: cluster_one.id,
    parent_node_id: node_six.id
  })

_server_seven = Repo.insert!(%Server{port: Enum.random(4_000..10_000), node_id: node_seven.id})

# Create nodes for cluster two
node_eight =
  Repo.insert!(%Node{
    type: :duck,
    status: :down,
    cluster_id: cluster_two.id,
    network_partition_id: network_partition_three.id
  })

_server_eight = Repo.insert!(%Server{port: Enum.random(4_000..10_000), node_id: node_eight.id})

node_nine =
  Repo.insert!(%Node{
    type: :duck,
    status: :down,
    cluster_id: cluster_two.id
  })

_server_nine = Repo.insert!(%Server{port: Enum.random(4_000..10_000), node_id: node_nine.id})

node_ten =
  Repo.insert!(%Node{
    type: :duck,
    status: :down,
    cluster_id: cluster_two.id,
    parent_node_id: node_nine.id
  })

_server_ten = Repo.insert!(%Server{port: Enum.random(4_000..10_000), node_id: node_ten.id})

node_eleven =
  Repo.insert!(%Node{
    type: :duck,
    status: :down,
    cluster_id: cluster_two.id,
    parent_node_id: node_ten.id
  })

_server_eleven = Repo.insert!(%Server{port: Enum.random(4_000..10_000), node_id: node_eleven.id})

node_twelve =
  Repo.insert!(%Node{
    type: :duck,
    status: :down,
    cluster_id: cluster_two.id,
    network_partition_id: network_partition_three.id
  })

_server_twelve = Repo.insert!(%Server{port: Enum.random(4_000..10_000), node_id: node_twelve.id})
