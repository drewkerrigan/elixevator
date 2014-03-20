defmodule Elixevator.Elevator.Fsm do
  use GenFSM.Behaviour

  defrecord State, floor: 1, goal: [{1, 0}]

  def start_link() do
    :gen_fsm.start_link(__MODULE__, [], [])
  end

  ### Callbacks

  def init(_args) do
    { :ok, :ready, State.new }
  end

  def ready(:get_status, _, state) do
    [{goal_floor, _} | _] = state.goal
    { :reply, {state.floor, goal_floor}, :ready, state }
  end

  def ready(:step, state) do
    current_floor = state.floor
    [{current_goal, _} | rest ] = state.goal

    with_new_floor = state.floor(get_next_floor(current_floor, current_goal))
    with_new_goal = state.goal(rest)

    { :next_state, :ready, with_new_floor }
  end

  def ready({:update, floor, goal}, state) do
    with_floor = state.floor(floor)
    with_goal = with_floor.goal([{goal, 0}])

    { :next_state, :ready, with_goal }
  end

  def ready({:pickup, goal, direction}, state) do
    with_goal = state.goal(state.goal ++ {goal, direction})

    { :next_state, :ready, with_goal }
  end

  def get_next_floor(floor, goal) when goal < floor do
    floor - 1
  end

  def get_next_floor(floor, goal) when goal > floor do
    floor + 1
  end

  def get_next_floor(floor, floor) do
    floor
  end

end