defmodule MarsPlanetTest do
  use ExUnit.Case
  doctest MarsPlanet

  setup do
    registry = start_supervised!({MarsPlanetServer, [5,5, [{3,3}, {1,1}]]})
    %{registry: registry}
  end

  test "is over the X max edge return opposit position", %{registry: _registry} do
    assert MarsPlanetServer.execute({:check_edge, {5,6}}) == {:ok, {5,0}}
  end

  test "is over the Y max edge return opposit position", %{registry: _registry} do
    assert MarsPlanetServer.execute({:check_edge, {1,6}}) == {:ok, {1,0}}
  end

  test "is over the Y min edge return opposit position", %{registry: _registry} do
    assert MarsPlanetServer.execute({:check_edge, {1,-1}}) == {:ok, {1,5}}
  end

  test "is over the X min edge return opposit position", %{registry: _registry} do
    assert MarsPlanetServer.execute({:check_edge, {-1,1}}) == {:ok, {5,1}}
  end

  test "check for obstacles, obstacle present", %{registry: _registry} do
    assert MarsPlanetServer.execute({:check_obstacle, {3,3}}) == {:ok, :obstacle}
  end

  test "check for obstacles, obstacle not present", %{registry: _registry} do
    assert MarsPlanetServer.execute({:check_obstacle, {2,2}}) == {:ok, :free}
  end
end
