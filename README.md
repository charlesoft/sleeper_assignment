# SleeperAssignment

## Introduction

This is an implementation for the 'Duck Duck Goose' Assignment. The code implemented to handle the cluster of nodes and the assignment's requirements used the idea of having a Supervisor (Cluster) to supervise/handle
its child proccesses (nodes).

## How to use it
First let's start get everything set up. Let's create our data by running:

```
mix ecto.setup
```

This will create the following tables along with seed data:

- Clusters
- Nodes
- NetworkPartions
- Server

Those are the data structures we will be handling in our application

Start the app:

```
iex -S mix
```

Let's start our cluster:

```elixir
alias SleeperAssignment.{Repo, Cluster}

[cluster_one, _cluster_two] = Repo.all(Cluster)

{:ok, cluster_pid} = ClusterSupervisor.start_link(cluster_one)
```

You should see a print like the one below showing the nodes and its HTTP servers getting started:

```
Starting node server for Node 1...
Node Name: :node_1
Starting node server for Node 2...
Node Name: :node_2
Starting node server for Node 3...
Node Name: :node_3

Starting HTTP server on port 5194...
Starting HTTP server on port 7190...
Starting HTTP server on port 4324...

Listening for connection requests on port 5194...


Listening for connection requests on port 7190...


Listening for connection requests on port 4324...

⌛️ Wating to accept client connection...
⌛️ Wating to accept client connection...
⌛️ Wating to accept client connection...
```

This means, the cluster was started and its node proccesses. Each http server for each node started listening ready to receive connections as you can see above.

If you type the localhost:5194 in our browser, you should receive a response like this saying the its Node status:

```
Node 5 is up!
```

And in your terminal:

```
← Response Sent:

HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: 16

Node 5 is up!

⌛️ Wating to accept client connection...
Connection accepted! 🎉
```

### Manipulating the nodes

There is a context module called `Nodes`, which will be interface to interact with the Nodes. Basically you will use it to update the given to say if its down or up, update to be the 'goose', if there was any network partition and so on by following the rules of the assignment.

Let's see some examples:

```elixir
alias SleeperAssignment.{Node, Nodes, Cluster}

node = Nodes.get_node(%{"cluster_id" => 1})

%SleeperAssignment.Node{
  __meta__: #Ecto.Schema.Metadata<:loaded, "nodes">,
  id: 6,
  type: :duck,
  status: :up,
  cluster_id: 1,
  cluster: #Ecto.Association.NotLoaded<association :cluster is not loaded>,
  network_partition_id: nil,
  network_partition: #Ecto.Association.NotLoaded<association :network_partition is not loaded>,
  server: #Ecto.Association.NotLoaded<association :server is not loaded>,
  inserted_at: ~N[2024-04-10 00:30:59],
  updated_at: ~N[2024-04-10 04:46:58]
}

attrs = %{"type" => "goose"}

Nodes.update(node, attrs)

{:ok,
 %SleeperAssignment.Node{
   __meta__: #Ecto.Schema.Metadata<:loaded, "nodes">,
   id: 6,
   type: :goose,
   status: :up,
   cluster_id: 1,
   cluster: #Ecto.Association.NotLoaded<association :cluster is not loaded>,
   network_partition_id: nil,
   network_partition: #Ecto.Association.NotLoaded<association :network_partition is not loaded>,
   server: #Ecto.Association.NotLoaded<association :server is not loaded>,
   inserted_at: ~N[2024-04-10 00:30:59],
   updated_at: ~N[2024-04-10 04:59:44]
 }}
```

You can use the example above to handle different scenarios for the nodes. If I want to say a node is down, I would pass the `attrs` as `%{"type" => "down"}`. Take a look at Nodes module implementation and its comments to get familiar on how it works.

To run tests you can basically type:

```
mix test
```

Make sure to take at the tests for the `Nodes` module at `test/sleeper_assignment/nodes_test.exs` which shows all the scenarios being tested. This will help understand how to use `Nodes` interface to interact this cluster of nodes.

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
