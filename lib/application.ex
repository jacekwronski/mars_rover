defmodule MarsRoverApplication do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = []#[{MarsRoverServer, ["opportunity"]}, {MarsPlanetServer, [5, 5, [{2,2}, {4,3}]]}]
    opts = [strategy: :one_for_one, name: MarsRoverApplication.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
