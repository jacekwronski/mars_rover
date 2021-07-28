defmodule CommandCenterServer do
  use GenServer

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: :command_center)
  end

  def init(_) do
    {:ok, %{}}
  end

  def execute_async(cmd) do
    GenServer.cast(:command_center, cmd)
  end

  def execute(cmd) do
    GenServer.call(:command_center, cmd)
  end

  def handle_call({:land, direction, x, y}, _from, state) do
    res = MarsRoverServer.land({direction, x, y})
    {:reply, res, state}
  end

  def handle_cast({:commands, commands}, state) do
    execute_commands(commands)
    {:noreply, state}
  end

  defp execute_commands(commands) do
    commands_list = String.split(commands, ",")
    execute_command(commands_list)
  end

  defp execute_command([]) do
    :ok
  end
  defp execute_command([command | other_commands]) do
    case command do
      t when t in ["l", "r"] ->
        turn_command(t)
        execute_command(other_commands)

      m when m in ["f", "b"] ->
        if move_command(m) == :ok do
          execute_command(other_commands)
        else
          :ok
        end

      _ ->
        :ok
    end
  end

  defp turn_command("l"), do: MarsRoverServer.execute({:turn, :left})
  defp turn_command("r"), do: MarsRoverServer.execute({:turn, :right})

  defp move_command("f"), do: MarsRoverServer.execute({:move, :forward})
  defp move_command("b"), do: MarsRoverServer.execute({:move, :backward})
end
