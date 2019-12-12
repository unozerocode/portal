defmodule Portal do
  defstruct [:left, :right]

@doc """
  Starts transferring 'data' from left to right
"""
def transfer(left, right, data) do
  # First add all the data to the portal on the left
  for item <- data do
    Portal.Door.push(left, item)
  end

  # Return a portal struct
  %Portal{left: left, right: right}
end

@doc """
  Pushes data to the right in the given portal
  """
  def push_right(portal) do
    # See if we can pop data from the left
    # if so, ´push it to the right
    # if not, do nothing

    case Portal.Door.pop(portal.left) do
      :error -> :ok
      {:ok, h} -> Portal.Door.push(portal.right, h)
    end

    # return the portal itself
    portal
  end
end
