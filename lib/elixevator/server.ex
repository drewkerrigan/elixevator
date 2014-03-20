defmodule Elixevator.Server do
  use GenServer.Behaviour

  defrecord State, elevators: nil

  def start_link([]) do
    :gen_server.start_link({ :local, :elixevator_server }, __MODULE__, [], [])
  end

  def init([]) do
    state = State.new(elevators: HashDict.new())
    { :ok, state }
  end

  ### Sync Functions

  def handle_call({:create, id}, {_, _}, state) do
    { :ok, pid } = Elixevator.Elevator.Fsm.start_link

    new_elevators = state.elevators |> HashDict.put(id, pid)

    {:reply, {:ok, id}, state.elevators(new_elevators)}
  end

  def handle_call({:get_status, id}, {_, _}, state) do
    pid = state.elevators |> HashDict.get(id)

    {floor, goal} = :gen_fsm.sync_send_event(pid, :get_status)

    {:reply, {:ok, {id, floor, goal}}, state}
  end

  ## Catchall
  def handle_call(_, _, state), do: {:reply, :error, state}

  ### Async Functions

  def handle_cast({:step, id}, state) do
    pid = state.elevators |> HashDict.get(id)

    :gen_fsm.send_event(pid, :step)

    {:noreply, state}
  end

  def handle_cast({:update, id, new_id, floor, goal}, state) do
    pid = state.elevators |> HashDict.get(id)

    :gen_fsm.send_event(pid, {:update, floor, goal})

    # Update id
    without_old_id = state.elevators |> HashDict.delete(id)
    with_new_id = without_old_id |> HashDict.put(new_id, pid)

    {:noreply, state.elevators(with_new_id)}
  end

  def handle_cast({:pickup, id, goal, direction}, state) do
    pid = state.elevators |> HashDict.get(id)

    :gen_fsm.send_event(pid, {:pickup, goal, direction})

    {:noreply, state}
  end

  ## Catchall
  def handle_cast(_, state), do: {:noreply, state}
end