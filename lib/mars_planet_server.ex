defmodule MarsPlanetServer do
  use GenServer

  def start_link([dim_x, dim_y, obstacles]) do
    GenServer.start_link(__MODULE__, [dim_x, dim_y, obstacles], name: :mars_planet)
  end

  def init([dim_x, dim_y, obstacles]) do
    Process.flag(:trap_exit, true)
    {:ok, %{dim_x: dim_x, dim_y: dim_y, obstacles: obstacles}}
  end

  def execute(cmd) do
    GenServer.call(:mars_planet, cmd)
  end

  def handle_call({:check_edge, {x, y}}, _from, %{dim_x: dim_x, dim_y: dim_y} = state) do
    {new_x, new_y} = calculate_position(x, y, dim_x, dim_y)
    {:reply, {:ok, {new_x, new_y}}, state}
  end

  def handle_call({:check_obstacle, {x, y}}, _from, %{obstacles: obstacles} = state) do

    position_has_obstacle = Enum.any?(obstacles, fn {ox, oy} -> ox == x && oy == y end)

    if (position_has_obstacle) do
      {:reply, {:ok, :obstacle}, state}
    else
      {:reply, {:ok, :free}, state}
    end
  end

  def calculate_position(x, y, dim_x, _) when x > dim_x, do: {0, y}
  def calculate_position(x, y, dim_x, _) when x < 0, do: {dim_x, y}
  def calculate_position(x, y, _, dim_y) when y > dim_y, do: {x, 0}
  def calculate_position(x, y, _, dim_y) when y < 0, do: {x, dim_y}
  def calculate_position(x, y, _, _), do: {x, y}
end
