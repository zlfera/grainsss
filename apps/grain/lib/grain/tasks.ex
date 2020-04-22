defmodule Grain.Tasks do
  @moduledoc false
  alias Grain.TaskGrain, as: Gt

  # import Ecto.Query

  def run(pid) do
    # {:ok, _} = Application.ensure_all_started(:grain)

    # a =
    #  Grain.Grains.Grain
    #  |> order_by(desc: :inserted_at)
    #  |> limit(20000)
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
    #  {year, store_no, storage_depot_name} = Grain.TaskGrain.get_year(x.request_no)

    #  p =
    #    Ecto.Changeset.change(x, year: year)
    #    |> Ecto.Changeset.change(store_no: store_no)
    #    |> Ecto.Changeset.change(storage_depot_name: storage_depot_name)

    #  Grain.Repo.update!(p)
    # end)

    p = Agent.get(pid, & &1)

    case {Enum.empty?(b()), Enum.empty?(p)} do
      {true, _} ->
        IO.puts("当前没有任务")

      {false, true} ->
        IO.puts("启动新任务")
        u1(b(), pid)

      {false, false} ->
        # Map.keys(p)
        # |> Enum.each(IO.puts(&Process.alive?(p[&1])))

        IO.puts("当前任务正在进行中")
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

    Process.sleep(1000)
    u1(b(), pid)
  end

  def u1(c, pid) when c == [] do
    Process.sleep(10000)
    IO.puts("交易已经结束")
    Agent.update(pid, &Map.drop(&1, Map.keys(&1)))
  end
end
