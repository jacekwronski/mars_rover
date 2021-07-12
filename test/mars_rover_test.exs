defmodule MarsRoverTest do
  use ExUnit.Case
  doctest MarsRover

  setup do
    registry = start_supervised!({MarsRoverServer, ["opportunity"]})
    %{registry: registry}
  end

  test "land rover", %{registry: registry} do
    assert MarsRoverServer.land() == :ok
  end

  test "turn rover right", %{registry: registry} do
    MarsRoverServer.land()
    MarsRoverServer.execute({:turn, :right})
    MarsRoverServer.execute(:get_state)  == {:ok, %{name: "opportunity", x: 0, y: 0, direction: :east}}
  end

  test "turn rover left", %{registry: registry} do
    MarsRoverServer.land()
    MarsRoverServer.execute({:turn, :left})
    MarsRoverServer.execute(:get_state)  == {:ok, %{name: "opportunity", x: 0, y: 0, direction: :west}}
  end

  test "turn rover :west turn left", %{registry: registry} do
    MarsRoverServer.land({:west, 0, 0})
    MarsRoverServer.execute({:turn, :left})
    MarsRoverServer.execute(:get_state)  == {:ok, %{name: "opportunity", x: 0, y: 0, direction: :north}}
  end

  test "turn rover :west turn right", %{registry: registry} do
    MarsRoverServer.land({:west, 0, 0})
    MarsRoverServer.execute({:turn, :left})
    MarsRoverServer.execute(:get_state)  == {:ok, %{name: "opportunity", x: 0, y: 0, direction: :south}}
  end

  test "turn rover :south turn left", %{registry: registry} do
    MarsRoverServer.land({:west, 0, 0})
    MarsRoverServer.execute({:turn, :left})
    MarsRoverServer.execute(:get_state)  == {:ok, %{name: "opportunity", x: 0, y: 0, direction: :west}}
  end

  test "turn rover :south turn right", %{registry: registry} do
    MarsRoverServer.land({:west, 0, 0})
    MarsRoverServer.execute({:turn, :left})
    MarsRoverServer.execute(:get_state)  == {:ok, %{name: "opportunity", x: 0, y: 0, direction: :east}}
  end

  test "turn rover :east turn left", %{registry: registry} do
    MarsRoverServer.land({:west, 0, 0})
    MarsRoverServer.execute({:turn, :left})
    MarsRoverServer.execute(:get_state)  == {:ok, %{name: "opportunity", x: 0, y: 0, direction: :north}}
  end

  test "turn rover :east turn right", %{registry: registry} do
    MarsRoverServer.land({:west, 0, 0})
    MarsRoverServer.execute({:turn, :left})
    MarsRoverServer.execute(:get_state)  == {:ok, %{name: "opportunity", x: 0, y: 0, direction: :south}}
  end


  test "turn rover :north turn 4 time right return to north", %{registry: registry} do
    MarsRoverServer.land({:north, 0, 0})
    MarsRoverServer.execute({:turn, :right})
    MarsRoverServer.execute({:turn, :right})
    MarsRoverServer.execute({:turn, :right})
    MarsRoverServer.execute({:turn, :right})
    MarsRoverServer.execute(:get_state)  == {:ok, %{name: "opportunity", x: 0, y: 0, direction: :north}}
  end

  test "turn rover :north turn 4 time left return to north", %{registry: registry} do
    MarsRoverServer.land({:north, 0, 0})
    MarsRoverServer.execute({:turn, :left})
    MarsRoverServer.execute({:turn, :left})
    MarsRoverServer.execute({:turn, :left})
    MarsRoverServer.execute({:turn, :left})
    MarsRoverServer.execute(:get_state)  == {:ok, %{name: "opportunity", x: 0, y: 0, direction: :north}}
  end

  test "rover at 2,2 face :north go forward positoi is 2,3", %{registry: registry} do
    MarsRoverServer.land({:north, 2, 2})
    MarsRoverServer.execute({:move, :forward})
    assert MarsRoverServer.execute(:get_state) == {:ok, %{name: "opportunity", x: 2, y: 3, direction: :north}}
  end

  test "rover at 2,2 face :south go forward positoi is 2,1", %{registry: registry} do
    MarsRoverServer.land({:south, 2, 2})
    MarsRoverServer.execute({:move, :forward})
    assert MarsRoverServer.execute(:get_state) == {:ok, %{name: "opportunity", x: 2, y: 1, direction: :south}}
  end

  test "rover at 2,2 face :north go backwad position is 2,1", %{registry: registry} do
    MarsRoverServer.land({:north, 2, 2})
    MarsRoverServer.execute({:move, :backward})
    assert MarsRoverServer.execute(:get_state) == {:ok, %{name: "opportunity", x: 2, y: 1, direction: :north}}
  end

  test "rover at 2,2 face :south go backwad position is 2,3", %{registry: registry} do
    MarsRoverServer.land({:south, 2, 2})
    MarsRoverServer.execute({:move, :backward})
    assert MarsRoverServer.execute(:get_state) == {:ok, %{name: "opportunity", x: 2, y: 3, direction: :south}}
  end

  test "rover at 2,2 face :east go farward position is 3,2", %{registry: registry} do
    MarsRoverServer.land({:east, 2, 2})
    MarsRoverServer.execute({:move, :forward})
    assert MarsRoverServer.execute(:get_state) == {:ok, %{name: "opportunity", x: 3, y: 2, direction: :east}}
  end

  test "rover at 2,2 face :east go backward position is 3,2", %{registry: registry} do
    MarsRoverServer.land({:east, 2, 2})
    MarsRoverServer.execute({:move, :backward})
    assert MarsRoverServer.execute(:get_state) == {:ok, %{name: "opportunity", x: 1, y: 2, direction: :east}}
  end

  test "rover at 2,2 face :west go foreward position is 1,2", %{registry: registry} do
    MarsRoverServer.land({:west, 2, 2})
    MarsRoverServer.execute({:move, :forward})
    assert MarsRoverServer.execute(:get_state) == {:ok, %{name: "opportunity", x: 1, y: 2, direction: :west}}
  end

  test "rover at 2,2 face :west go backward position is 3,2", %{registry: registry} do
    MarsRoverServer.land({:west, 2, 2})
    MarsRoverServer.execute({:move, :backward})
    assert MarsRoverServer.execute(:get_state) == {:ok, %{name: "opportunity", x: 3, y: 2, direction: :west}}
  end
end
