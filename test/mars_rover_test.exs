defmodule MarsRoverTest do
  use ExUnit.Case
  doctest MarsRover

  setup do
    registry = start_supervised!({MarsRoverServer, ["opportunity"]})
    start_supervised!({MarsPlanetServer, [5, 5, [{1,1}, {3,3}]]})
    %{registry: registry}
  end

  test "land rover", %{registry: _registry} do
    assert MarsRoverServer.land() == :ok
  end

  test "turn rover right", %{registry: _registry} do
    MarsRoverServer.land()
    MarsRoverServer.execute({:turn, :right})
    assert MarsRoverServer.execute(:get_state)  == {:ok, %{name: "opportunity", x: 0, y: 0, direction: :east}}
  end

  test "turn rover left", %{registry: _registry} do
    MarsRoverServer.land()
    MarsRoverServer.execute({:turn, :left})
    assert MarsRoverServer.execute(:get_state)  == {:ok, %{name: "opportunity", x: 0, y: 0, direction: :west}}
  end

  test "turn rover :west turn left", %{registry: _registry} do
    MarsRoverServer.land({:west, 0, 0})
    MarsRoverServer.execute({:turn, :left})
    assert MarsRoverServer.execute(:get_state)  == {:ok, %{name: "opportunity", x: 0, y: 0, direction: :south}}
  end

  test "turn rover :west turn right", %{registry: _registry} do
    MarsRoverServer.land({:west, 0, 0})
    MarsRoverServer.execute({:turn, :right})
    assert MarsRoverServer.execute(:get_state)  == {:ok, %{name: "opportunity", x: 0, y: 0, direction: :north}}
  end

  test "turn rover :south turn left", %{registry: _registry} do
    MarsRoverServer.land({:south, 0, 0})
    MarsRoverServer.execute({:turn, :left})
    assert MarsRoverServer.execute(:get_state)  == {:ok, %{name: "opportunity", x: 0, y: 0, direction: :east}}
  end

  test "turn rover :south turn right", %{registry: _registry} do
    MarsRoverServer.land({:south, 0, 0})
    MarsRoverServer.execute({:turn, :right})
    assert MarsRoverServer.execute(:get_state)  == {:ok, %{name: "opportunity", x: 0, y: 0, direction: :west}}
  end

  test "turn rover :east turn left", %{registry: _registry} do
    MarsRoverServer.land({:east, 0, 0})
    MarsRoverServer.execute({:turn, :left})
    assert MarsRoverServer.execute(:get_state)  == {:ok, %{name: "opportunity", x: 0, y: 0, direction: :north}}
  end

  test "turn rover :east turn right", %{registry: _registry} do
    MarsRoverServer.land({:east, 0, 0})
    MarsRoverServer.execute({:turn, :right})
    assert MarsRoverServer.execute(:get_state)  == {:ok, %{name: "opportunity", x: 0, y: 0, direction: :south}}
  end


  test "turn rover :north turn 4 time right return to north", %{registry: _registry} do
    MarsRoverServer.land({:north, 0, 0})
    MarsRoverServer.execute({:turn, :right})
    MarsRoverServer.execute({:turn, :right})
    MarsRoverServer.execute({:turn, :right})
    MarsRoverServer.execute({:turn, :right})
    assert MarsRoverServer.execute(:get_state)  == {:ok, %{name: "opportunity", x: 0, y: 0, direction: :north}}
  end

  test "turn rover :north turn 4 time left return to north", %{registry: _registry} do
    MarsRoverServer.land({:north, 0, 0})
    MarsRoverServer.execute({:turn, :left})
    MarsRoverServer.execute({:turn, :left})
    MarsRoverServer.execute({:turn, :left})
    MarsRoverServer.execute({:turn, :left})
    assert MarsRoverServer.execute(:get_state)  == {:ok, %{name: "opportunity", x: 0, y: 0, direction: :north}}
  end

  test "rover at 2,2 face :north go forward positoi is 2,3", %{registry: _registry} do
    MarsRoverServer.land({:north, 2, 2})
    MarsRoverServer.execute({:move, :forward})
    assert MarsRoverServer.execute(:get_state) == {:ok, %{name: "opportunity", x: 2, y: 3, direction: :north}}
  end

  test "rover at 2,2 face :south go forward positoi is 2,1", %{registry: _registry} do
    MarsRoverServer.land({:south, 2, 2})
    MarsRoverServer.execute({:move, :forward})
    assert MarsRoverServer.execute(:get_state) == {:ok, %{name: "opportunity", x: 2, y: 1, direction: :south}}
  end

  test "rover at 2,2 face :north go backwad position is 2,1", %{registry: _registry} do
    MarsRoverServer.land({:north, 2, 2})
    MarsRoverServer.execute({:move, :backward})
    assert MarsRoverServer.execute(:get_state) == {:ok, %{name: "opportunity", x: 2, y: 1, direction: :north}}
  end

  test "rover at 2,2 face :south go backwad position is 2,3", %{registry: _registry} do
    MarsRoverServer.land({:south, 2, 2})
    MarsRoverServer.execute({:move, :backward})
    assert MarsRoverServer.execute(:get_state) == {:ok, %{name: "opportunity", x: 2, y: 3, direction: :south}}
  end

  test "rover at 2,2 face :east go farward position is 3,2", %{registry: _registry} do
    MarsRoverServer.land({:east, 2, 2})
    MarsRoverServer.execute({:move, :forward})
    assert MarsRoverServer.execute(:get_state) == {:ok, %{name: "opportunity", x: 3, y: 2, direction: :east}}
  end

  test "rover at 2,2 face :east go backward position is 3,2", %{registry: _registry} do
    MarsRoverServer.land({:east, 2, 2})
    MarsRoverServer.execute({:move, :backward})
    assert MarsRoverServer.execute(:get_state) == {:ok, %{name: "opportunity", x: 1, y: 2, direction: :east}}
  end

  test "rover at 2,2 face :west go foreward position is 1,2", %{registry: _registry} do
    MarsRoverServer.land({:west, 2, 2})
    MarsRoverServer.execute({:move, :forward})
    assert MarsRoverServer.execute(:get_state) == {:ok, %{name: "opportunity", x: 1, y: 2, direction: :west}}
  end

  test "rover at 2,2 face :west go backward position is 3,2", %{registry: _registry} do
    MarsRoverServer.land({:west, 2, 2})
    MarsRoverServer.execute({:move, :backward})
    assert MarsRoverServer.execute(:get_state) == {:ok, %{name: "opportunity", x: 3, y: 2, direction: :west}}
  end

  test "rover at 5,1 move out of edge return to pos 0,1 ", %{registry: _registry} do
    MarsRoverServer.land({:west, 5, 1})
    MarsRoverServer.execute({:move, :backward})
    assert MarsRoverServer.execute(:get_state) == {:ok, %{name: "opportunity", x: 0, y: 1, direction: :west}}
  end

  test "rover at 1,5 move out of edge return to pos 0,1 ", %{registry: _registry} do
    MarsRoverServer.land({:north, 1, 5})
    MarsRoverServer.execute({:move, :forward})
    assert MarsRoverServer.execute(:get_state) == {:ok, %{name: "opportunity", x: 1, y: 0, direction: :north}}
  end

  test "rover at 1,0 move forward check for obstacle final position 1,0", %{registry: _registry} do
    MarsRoverServer.land({:north, 1, 0})
    MarsRoverServer.execute({:move, :forward})
    assert MarsRoverServer.execute(:get_state) == {:ok, %{name: "opportunity", x: 1, y: 0, direction: :north}}
  end
end
