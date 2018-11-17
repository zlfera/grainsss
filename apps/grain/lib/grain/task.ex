# defmodule Grain.Task do
# use GenServer

# def start_link do
#   GenServer.start_link(__MODULE__, %{})
# end

# def init(state) do
# Schedule work to be performed at some point
#  schedule_work()
# {:ok, state}
# end

# def handle_info(:task, state) do
# Do the work you desire here
# Reschedule once more
# {:ok, pid} = Agent.start_link(fn -> %{} end)
# Grain.Tasks.run(pid)
# schedule_work()
# {:noreply, state}
# end

# defp schedule_work() do
# In 2 hours
# Process.send_after(self(), :task, 1000 * 60 * 60 * 12)
# end
# end
