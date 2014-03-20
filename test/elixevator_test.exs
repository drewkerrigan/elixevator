defmodule ElixevatorTest do
  use ExUnit.Case

  test "adding an elevator creates a pid" do
    {:ok, id} = Elixevator.create(1)

    assert(is_integer(id))
  end

  test "new elevators have a state" do
    expected_state = {2, 1, 1}

    Elixevator.create(2)

    {:ok, actual_state} = Elixevator.get_status(2)

    assert expected_state == actual_state
  end

  test "nothing happens on step for new elevator" do
    expected_state = {3, 1, 1}

    Elixevator.create(3)

    Elixevator.step(3)

    {:ok, actual_state} = Elixevator.get_status(3)

    assert expected_state == actual_state
  end

  test "an elevator state can be manually set" do
    expected_state = {5, 5, 5}

    Elixevator.create(4)

    Elixevator.update(4, 5, 5, 5)

    {:ok, actual_state} = Elixevator.get_status(5)

    assert expected_state == actual_state
  end

  test "an elevator state changes after pickup" do
    Elixevator.create(6)

    :ok = Elixevator.pickup(6, 3, 1)

    Elixevator.step(6)

    assert {:ok, {6, 2, 3}} == Elixevator.get_status(6)

    Elixevator.step(6)

    assert {:ok, {6, 3, 3}} == Elixevator.get_status(6)

    Elixevator.step(6)

    assert {:ok, {6, 3, 3}} == Elixevator.get_status(6)

  end
end
