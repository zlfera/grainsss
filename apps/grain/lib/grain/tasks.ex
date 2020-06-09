defmodule Grain.Tasks do
  @moduledoc false
  alias Grain.TaskGrain, as: Gt

  # import Ecto.Query

  def run(pid) do
    # {:ok, _} = Application.ensure_all_started(:grain)

    # a =
    #  Grain.Grains.Grain
    #  |> order_by(desc: :inserted_at)
    #  |> limit(30000)
    #  |> Grain.Repo.all()

    # aa =
    #  Enum.reject(a, fn x ->
    #    Map.has_key?(x, :request_no) == false
    #  end)

    # |> Enum.reject(fn x ->
    #  Map.has_key?(x, :store_no) == false
    # end)
    # |> Enum.reject(fn x ->
    #  Map.has_key?(x, :storage_depot_name) == false
    # end)

    # aaa =
    #  Enum.reject(a, fn x ->
    #    x.request_no == nil
    #  end)

    # |> Enum.reject(fn x ->
    #  x.store_no == nil
    # end)
    # |> Enum.reject(fn x ->
    #  x.storage_depot_name == nil
    # end)

    # Enum.each(aaa, fn x ->
    #  maps = Grain.TaskGrain.get_year(x.request_no)

    #  p = Ecto.Changeset.change(x, market_name: maps["marketName"])
    # |> Ecto.Changeset.change(store_no: store_no)
    # |> Ecto.Changeset.change(storage_depot_name: storage_depot_name)

    #  zzz = Grain.Repo.update!(p)
    #  IO.inspect(zzz)
    # end)

    p = Agent.get(pid, & &1)

    case {Enum.empty?(b()), Enum.empty?(p)} do
      {true, _} ->
        IO.puts("当前没有任务")

      {false, true} ->
        IO.puts("启动新任务")
        u1(b(), pid)

      {false, false} ->
        IO.puts("######")

        Map.values(p)
        |> Enum.each(fn x -> IO.puts(Process.alive?(x)) end)

        IO.puts("当前任务正在进行中")
        IO.puts("######")
    end

    spawn(HTTPoison, :get, ["https://youmilegg.herokuapp.com/home/grain_home"])
    spawn(HTTPoison, :get, ["https://youmile.herokuapp.com/home/grain_home"])
  end

  def b do
    uuu = "http://123.127.88.167:8888/tradeClient/observe/specialList"

    case HTTPoison.get(uuu) do
      {:ok, url} ->
        url.body |> Jason.decode!()

      {:error, _} ->
        b()
    end
  end

  def u1(c, pid) when c != [] do
    Enum.each(c, fn x ->
      y = x["specialNo"]
      qww = Agent.get(pid, & &1)
      IO.puts("@@@@@@")
      IO.inspect(qww)
      IO.puts("@@@@@@")

      cond do
        qww[y] == nil ->
          {:ok, pid_list} = Agent.start_link(fn -> [] end)
          i = spawn(Gt, :grain, [y, pid_list])
          Agent.update(pid, &Map.put(&1, y, i))

        is_pid(qww[y]) == false ->
          IO.puts("参数错误")

        Process.alive?(qww[y]) == true ->
          Map.keys(qww)
          |> Enum.each(fn x ->
            if !Process.alive?(qww[x]) do
              Agent.update(pid, &Map.delete(qww, &1))
            end
          end)
      end

      qww = Agent.get(pid, & &1)
      IO.puts("$$$$$$")
      IO.inspect(Process.alive?(qww[y]))
      IO.puts("$$$$$$")
      # if Map.has_key?(qww, y) do
      #  Enum.each(Map.keys(qww), fn k ->
      #    if !Process.alive?(qww[k]) do
      #      Agent.update(pid, &Map.delete(&1, k))
      #    end
      #  end)
      # else
      #  {:ok, pid_list} = Agent.start_link(fn -> [] end)
      #  i = spawn(Gt, :grain, [y, pid_list])
      #  Agent.update(pid, &Map.put(&1, y, i))
      # end
    end)

    Process.sleep(2000)
    u1(b(), pid)
  end

  def u1(c, pid) when c == [] do
    rows_map = Agent.get(pid, & &1)
    IO.inspect(rows_map)

    # if Enum.empty?(rows_map) do
    #  IO.puts("任务已经结束")
    # else
    #  Enum.each(Map.values(rows_map), fn i -> Task.await(i, 50000) end)
    Process.sleep(15000)
    IO.puts("交易已经结束")
    Agent.update(pid, &Map.drop(&1, Map.keys(&1)))
    # end
  end
end
