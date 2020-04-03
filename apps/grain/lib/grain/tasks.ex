defmodule Grain.Tasks do
  @moduledoc false
  alias Grain.TaskGrain, as: Gt

  def run(pid) do
    # {:ok, _} = Application.ensure_all_started(:grain)
    # a = Grain.Repo.all(Grain.Grains.Grain)

    # aa =
    #  Enum.reject(a, fn x ->
    #    Map.has_key?(x, :request_no) == false
    #  end)

    # aaa =
    #  Enum.reject(aa, fn x ->
    #    x.request_no == nil
    #  end)

    # Enum.each(aaa, fn x ->
    #  year = Grain.TaskGrain.get_year(x.request_no)
    #  p = Ecto.Changeset.change(x, year: year)
    #  Grain.Repo.update!(p)
    # end)

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

    spawn(HTTPoison, :get, ["https://youmilegg.herokuapp.com/home/grain_home"])
    spawn(HTTPoison, :get, ["https://youmile.herokuapp.com/home/grain_home"])
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
        Enum.each(Map.keys(qww), fn k ->
          if !Process.alive?(qww[k]) do
            Agent.update(pid, &Map.delete(&1, k))
          end
        end)
      else
        {:ok, pid_list} = Agent.start_link(fn -> [] end)
        i = spawn(Gt, :grain, [y, pid_list])
        Agent.update(pid, &Map.put(&1, y, i))
      end
    end)

    Process.sleep(15000)
    u1(b(), pid)
  end

  def u1(c, pid) when c == [] do
    Process.sleep(10000)
    IO.puts("交易已经结束")
    Agent.update(pid, &Map.drop(&1, Map.keys(&1)))
  end
end
