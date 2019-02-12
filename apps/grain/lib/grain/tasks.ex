defmodule Grain.Tasks do
  @moduledoc false
  alias Grain.TaskGrain, as: Gt

  def run(pid) do
    {:ok, _} = Application.ensure_all_started(:grain)
    p = Agent.get(pid, & &1)
    IO.inspect(p)

    if b() != [] do
      if p != %{} do
        Map.keys(p) |> Enum.each(&(Process.alive?(p[&1]) |> IO.puts()))
        IO.puts("当前任务正在进行中")
      else
        "启动新任务" |> IO.puts()
        u1(b(), pid)
      end
    end

    HTTPoison.get("https://youmilegg.herokuapp.com/home/grain_home")
    HTTPoison.get("https://youmile.herokuapp.com/home/grain_home")
  end

  def b do
    uuu = "http://123.127.88.167:8888/tradeClient/observe/specialList"
    {o, url} = HTTPoison.get(uuu)

    if o == :ok do
      url.body |> Jason.decode!()
    else
      b()
    end
  end

  def u1(c, pid) when c != [] do
    Enum.each(c, fn x ->
      y = x["specialNo"]
      qww = Agent.get(pid, & &1)

      if Map.has_key?(qww, y) do
        if !Process.alive?(qww[y]) do
          IO.inspect("#{y} is false")
          Agent.update(pid, &Map.delete(&1, y))
          IO.inspect(Agent.get(pid, & &1))
        end
      else
        IO.inspect("#{y} is nil")
        {:ok, pid_list} = Agent.start_link(fn -> [] end)
        i = spawn(Gt, :grain, [y, pid_list])
        Agent.update(pid, &Map.put(&1, y, i))
      end
    end)

    u1(b(), pid)
  end

  def u1(c, pid) when c == [] do
    IO.puts("交易已经结束")
    Agent.update(pid, &Map.drop(&1, Map.keys(&1)))
    IO.inspect(Agent.get(pid, & &1))
  end
end
