defmodule MarsRoverServer do
  use GenServer

  def start_link([name]) do
    GenServer.start_link(__MODULE__, [name], name: :rover)
  end

  def init([name]) do
    Process.flag(:trap_exit, true)
    {:ok, %{name: name, x: nil, y: nil, direction: nil}}
  end

  def land({direction, x, y}) do
    GenServer.call(:rover, {:land, direction, x, y})
  end

  def land() do
    GenServer.call(:rover, {:land, :north, 0, 0})
  end

  def execute(cmd) do
    GenServer.call(:rover, cmd)
  end

  def handle_call({:turn, turn_direction}, _from, %{direction: direction} = state) do
    new_direction = turn(turn_direction, direction)
    {:reply, :ok, %{state | x: 0, y: 0, direction: new_direction}}
  end

  def handle_call({:land, direction, x, y}, _from, state) do
    {:reply, :ok, %{state | x: x, y: y, direction: direction}}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def handle_call({:move, :forward}, _from, %{direction: direction, x: x, y: y} = state) do
    {new_x, new_y} = move(:forward, direction, {x, y})
    {:ok, {px, py}} = MarsPlanetServer.execute({:check_edge, {new_x, new_y}})
    {:reply, :ok, %{state | x: px, y: py}}
  end

  def handle_call({:move, :backward}, _from, %{direction: direction, x: x, y: y} = state) do
    {new_x, new_y} = move(:backward, direction, {x, y})
    {:ok, {px, py}} = MarsPlanetServer.execute({:check_edge, {new_x, new_y}})
    {:reply, :ok, %{state | x: px, y: py}}
  end

  def move(:forward, :north, {x, y}), do: {x, y + 1}
  def move(:forward, :south, {x, y}), do: {x, y - 1}
  def move(:forward, :east, {x, y}), do: {x + 1, y}
  def move(:forward, :west, {x, y}), do: {x - 1, y}
  def move(:backward, :north, {x, y}), do: {x, y - 1}
  def move(:backward, :south, {x, y}), do: {x, y + 1}
  def move(:backward, :east, {x, y}), do: {x - 1, y}
  def move(:backward, :west, {x, y}), do: {x + 1, y}

  def turn(:left, :north), do: :west
  def turn(:right, :north), do: :east
  def turn(:left, :west), do: :south
  def turn(:right, :west), do: :north
  def turn(:left, :south), do: :east
  def turn(:right, :south), do: :west
  def turn(:left, :east), do: :north
  def turn(:right, :east), do: :south
end
