defmodule Grain.Tasks do
  @moduledoc false
  import Ecto.Query
  alias Grain.Grains.Grain, as: G
  alias Grain.Repo
  alias Grain.Tasks, as: Gt

  def run(pid) do
    HTTPoison.get("https://youmilegg.herokuapp.com/home/grain_home")
    {:ok, _} = Application.ensure_all_started(:grain)
    IO.inspect(pid)
    Agent.get(pid, & &1) |> IO.inspect()
    p = Agent.get(pid, & &1)

    if b() != [] do
      # if p != %{} do
      Map.keys(p) |> Enum.each(&(Process.alive?(p[&1]) |> IO.puts()))
      # IO.puts("当前任务正在进行中")
      # else
      # "启动新任务" |> IO.puts()
      u1(b(), pid)
      # end
    end
  end

  def a(dqqq) do
    uu = "http://123.127.88.167:8888/tradeClient/observe/requestList?specialNo="
    u = uu <> dqqq

    HTTPoison.get!(u).body |> Jason.decode!()
  end

  def s(d, dd) do
    x = d["requestAlias"]

    dd =
      if Regex.match?(~r/销售/, dd) do
        "拍卖"
      else
        "采购"
      end

    y =
      if String.length(x) <= 12 || String.length(x) == 13 || String.length(x) == 15 do
        y = ~r/^\d+/ |> Regex.run(x)

        if y == nil do
          "00"
        else
          y |> List.to_string()
        end
      else
        x |> String.slice(11, 2)
      end

    attr = %{
      market_name: "guojia",
      mark_number: d["requestAlias"],
      year: y,
      variety: d["varietyName"],
      grade: d["gradeName"],
      trade_amount: d["num"],
      starting_price: d["basePrice"],
      latest_price: d["currentPrice"],
      address: d["requestBuyDepotName"],
      status: d["statusName"],
      trantype: dd
    }

    changeset = G.changeset(%G{}, attr)
    Repo.insert(changeset)
  end

  def b do
    uuu = "http://123.127.88.167:8888/tradeClient/observe/specialList"
    HTTPoison.get!(uuu).body |> Jason.decode!()
  end

  def j(j, d) do
    if String.to_integer(j["remainSeconds"]) <= 3 do
      g =
        G
        |> Ecto.Query.where([g], g.mark_number == ^j["requestAlias"])
        |> limit(1)
        |> Grain.Repo.all()

      if g == [] do
        s(j, d)
      end
    end
  end

  def grain(y) do
    dd = a(y)
    ddd = dd["specialName"]

    case dd["status"] do
      "yes" ->
        Enum.each(dd["rows"], fn jj ->
          if String.match?(jj["varietyName"], ~r/玉米/) || String.match?(jj["varietyName"], ~r/麦/) ||
               String.match?(jj["varietyName"], ~r/油/) || String.match?(jj["varietyName"], ~r/豆/) do
          else
            j(jj, ddd)
          end
        end)

        grain(y)

      "end" ->
        IO.puts("The status #{y} is end")

      "no" ->
        IO.puts("The status #{y} is no")

      _ ->
        grain(y)
    end
  end

  def u1(c, pid) when c != [] do
    Enum.each(c, fn x ->
      y = x["specialNo"]
      qww = Agent.get(pid, & &1)

      if Map.has_key?(qww, y) do
        if !Process.alive?(qww[y]) do
          IO.inspect(qww[y])
          IO.inspect("is false")
          Agent.update(pid, &Map.delete(&1, y))
        end
      else
        IO.inspect("#{qww[y]} is nil")
        i = spawn(Gt, :grain, [y])
        Agent.update(pid, &Map.put(&1, y, i))
        ref = Process.monitor(i)

        receive do
          {:DOWN, ^ref, :process, ^i, :normal} ->
            IO.inspect("Normal exit")

          {:DOWN, ^ref, :process, ^i, _msg} ->
            IO.inspect("the pid is false")
            u1(b(), pid)
        after
          50 ->
            IO.inspect("the pid is alive")
        end
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
