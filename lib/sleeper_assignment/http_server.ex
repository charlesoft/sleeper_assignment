defmodule SleeperAssignment.HttpServer do
  @moduledoc """
  HTTP server that listens for incoming connections and serves them.
  """
  def start(port) do
    IO.puts("Starting HTTP server on port #{port}...")

    {:ok, listen_socket} =
      :gen_tcp.listen(port, [:binary, packet: :raw, active: false, reuseaddr: true])

    IO.puts("\n Listening for connection requests on port #{port}...\n")

    accept_loop(listen_socket)
  end

  @doc """
  Accepts client connections and serves them.
  """
  def accept_loop(listen_socket) do
    IO.puts("⌛️ Wating to accept client connection...")

    {:ok, client_socket} = :gen_tcp.accept(listen_socket)

    IO.puts("Connection accepted! 🎉\n")

    serve(client_socket)

    accept_loop(listen_socket)
  end

  @doc """
  Serves the client by reading the request, generating a response, and writing the response.
  """
  def serve(client_socket) do
    client_socket
    |> read_request()
    |> generate_response()
    |> write_response(client_socket)
  end

  @doc """
  Reads the request from the client socket.
  """
  def read_request(socket) do
    {:ok, request} = :gen_tcp.recv(socket, 0)

    IO.puts("→ Request Received:\n")
    IO.puts(request)

    request
  end

  @doc """
  Returns a generic HTTP response.
  """
  def generate_response(_request) do
    """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 16\r
    \r
    There you go!
    """
  end

  @doc """
  Writes the response to the client socket.
  """
  def write_response(response, client_socket) do
    :ok = :gen_tcp.send(client_socket, response)

    IO.puts("← Response Sent:\n")
    IO.puts(response)

    # Closes the client socket connection
    :gen_tcp.close(client_socket)
  end
end
