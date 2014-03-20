defmodule Elixevator do
  use Application.Behaviour

  ###API Functions
  def start(_type, _args) do
    Elixevator.Supervisor.start_link
  end

  def create(id) do
    :gen_server.call(:elixevator_server, {:create, id})
  end

  def get_status(id) do
    :gen_server.call(:elixevator_server, {:get_status, id})
  end

  def step(id) do
    :gen_server.call(:elixevator_server, {:step, id})
  end

  def update(id, new_id, floor, goal) do
    :gen_server.cast(:elixevator_server, {:update, id, new_id, floor, goal})
  end

  def pickup(id, goal, direction) do
    :gen_server.cast(:elixevator_server, {:pickup, id, goal, direction})
  end
end
