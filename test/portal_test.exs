defmodule PortalTest do
  use ExUnit.Case
  require Portal.Door

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
    Portal.Door.start_link(:green)
    assert (Portal.Door.pop(:green) == :error)
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
end
