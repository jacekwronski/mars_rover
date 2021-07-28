defmodule CommandCenterTest do
  use ExUnit.Case
  doctest CommandCenter


  setup do
    start_supervised!({MarsRoverServer, ["opportunity"]})
    start_supervised!({MarsPlanetServer, [5, 5, [{1,1}, {1,5}, {3,3}]]})
    start_supervised!({CommandCenterServer, []})
    %{registry: {}}
  end

  test "land rover", %{registry: _registry} do
    assert CommandCenterServer.execute({:land, :north, 0, 0}) == :ok
  end

  test "position 0,0 facing east receive l,f,f,f", %{registry: _registry} do
    CommandCenterServer.execute({:land, :east, 0, 0})
    CommandCenterServer.execute_async({:commands, "l,f,f,f"})
    Process.sleep(200)
    assert MarsRoverServer.execute(:get_state)  == {:ok, %{name: "opportunity", x: 0, y: 3, direction: :north}}
  end

  test "position 0,0 facing east receive r,f,f,f", %{registry: _registry} do
    CommandCenterServer.execute({:land, :east, 0, 0})
    CommandCenterServer.execute_async({:commands, "r,f,f,f"})
    Process.sleep(200)
    assert MarsRoverServer.execute(:get_state)  == {:ok, %{name: "opportunity", x: 0, y: 3, direction: :south}}
  end

  test "position 0,0 facing east receive l,l,f,f,f", %{registry: _registry} do
    CommandCenterServer.execute({:land, :east, 0, 0})
    CommandCenterServer.execute_async({:commands, "l,l,f,f,f"})
    Process.sleep(200)
    assert MarsRoverServer.execute(:get_state)  == {:ok, %{name: "opportunity", x: 3, y: 0, direction: :west}}
  end

  test "position 0,0 facing east receive l,l,f,b,f", %{registry: _registry} do
    CommandCenterServer.execute({:land, :east, 0, 0})
    CommandCenterServer.execute_async({:commands, "l,l,f,b,f"})
    Process.sleep(200)
    assert MarsRoverServer.execute(:get_state)  == {:ok, %{name: "opportunity", x: 5, y: 0, direction: :west}}
  end

  test "position 0,0 facing east receive f,f,l,f,f,b", %{registry: _registry} do
    CommandCenterServer.execute({:land, :east, 0, 0})
    CommandCenterServer.execute_async({:commands, "f,f,l,f,f,b"})
    Process.sleep(200)
    assert MarsRoverServer.execute(:get_state)  == {:ok, %{name: "opportunity", x: 2, y: 1, direction: :north}}
  end

  test "position 0,0 facing east receive f,l,f", %{registry: _registry} do
    CommandCenterServer.execute({:land, :east, 0, 0})
    CommandCenterServer.execute_async({:commands, "f,l,f"})
    Process.sleep(200)
    assert MarsRoverServer.execute(:get_state)  == {:ok, %{name: "opportunity", x: 1, y: 0, direction: :north}}
  end

  test "position 0,0 facing east receive f,l,f,f", %{registry: _registry} do
    CommandCenterServer.execute({:land, :east, 0, 0})
    CommandCenterServer.execute_async({:commands, "f,l,f,f"})
    Process.sleep(200)
    assert MarsRoverServer.execute(:get_state)  == {:ok, %{name: "opportunity", x: 1, y: 0, direction: :north}}
  end

  test "position 0,0 facing east receive f,l,f,l,f", %{registry: _registry} do
    CommandCenterServer.execute({:land, :east, 0, 0})
    CommandCenterServer.execute_async({:commands, "f,l,f,f"})
    Process.sleep(200)
    assert MarsRoverServer.execute(:get_state)  == {:ok, %{name: "opportunity", x: 1, y: 0, direction: :north}}
  end
end
