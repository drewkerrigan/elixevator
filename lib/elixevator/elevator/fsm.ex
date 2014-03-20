defmodule Elixevator.Elevator.Fsm do
  use GenFSM.Behaviour

  defrecord State, floor: 1, goal: []

  def start_link() do
    :gen_fsm.start_link(__MODULE__, [], [])
  end

  ### Callbacks

  def init(_args) do
    { :ok, :ready, State.new }
  end

  def ready(:get_status, _, state) do
    goal_floor = get_current_goal_floor(state.floor, state.goal)

    { :reply, {state.floor, goal_floor}, :ready, state }
  end

  def ready(:step, state) do
    goal_floor = get_current_goal_floor(state.floor, state.goal)

    with_new_floor = state.floor(get_next_floor(state.floor, goal_floor))
    with_new_goal = with_new_floor.goal(get_next_goal(state.floor, with_new_floor.goal))

    { :next_state, :ready, with_new_goal }
  end

  def ready({:update, floor, goal}, state) do
    with_floor = state.floor(floor)
    with_goal = with_floor.goal([{goal, 0}])

    { :next_state, :ready, with_goal }
  end

  def ready({:pickup, goal, direction}, state) do
    old_goal = state.goal
    with_goal = state.goal(old_goal ++ [{goal, direction}])

    { :next_state, :ready, with_goal }
  end

  ### Utilities

  def get_next_floor(floor, goal) when goal < floor do
    floor - 1
  end

  def get_next_floor(floor, goal) when goal > floor do
    floor + 1
  end

  def get_next_floor(floor, floor) do
    floor
  end

  def get_next_goal(floor, []) do
    [{floor,0}]
  end

  def get_next_goal(_, [{g, d}]) do
    [{g,d}]
  end

  def get_next_goal(_, [_ | r]) do
    r
  end

  def get_current_goal_floor(_, [{goal_floor, _} | _]) do
    goal_floor
  end

  def get_current_goal_floor(floor, []) do
    floor
  end

end