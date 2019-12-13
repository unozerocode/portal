defmodule PortalTest do
  use ExUnit.Case
  require Portal.Door
  require Portal.Application

  doctest Portal

  test "Starts empty" do
    Portal.Door.start_link(:pink)
    assert (Portal.Door.get(:pink) == [])
  end

  test "Push a value" do
    Portal.Door.start_link(:blue)
    Portal.Door.push(:blue, 3)
    assert (Portal.Door.pop(:blue) == {:ok,3})
  end

  test "Pop empty is error" do
    Portal.Door.start_link(:purple)
    assert (Portal.Door.pop(:purple) == :error)
  end

  test "Transfer" do
    Portal.Door.start_link(:red)
    Portal.Door.start_link(:green)

    portal = Portal.transfer(:red, :green, [1,2,3]) # Connect the portals
    # Check left portal
    assert(Portal.Door.get(:red) == [3,2,1])
    # Push right
    Portal.push_right(portal)
    assert(Portal.Door.get(:red) == [2,1])
    assert(Portal.Door.get(:green) == [3])

  end

  test "1000 portals" do
    Enum.map(1..1000, fn x -> Portal.shoot(:"L#{x}") end)
    Enum.map(1..1000, fn x -> Portal.shoot(:"R#{x}") end)
    portals = Enum.map(1..1000, fn x -> Portal.transfer(:"L#{x}", :"R#{x}", 1..100) end)
    Enum.map(portals, fn %Portal{left: left, right: _right} -> assert (Portal.Door.get(left) == Enum.reverse(1..100)) end)
    Enum.map(1..100, fn _x ->
      Enum.map(portals, fn p -> Portal.push_right(p) end)
    end)

    Enum.map(portals, fn %Portal{left: _left, right: right} -> assert (Portal.Door.get(right) == Enum.to_list(1..100)) end)
  end
end
