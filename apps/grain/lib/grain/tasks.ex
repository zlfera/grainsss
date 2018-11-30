defmodule Grain.Tasks do
  @moduledoc false
  import Ecto.Query
  alias Grain.Grains.Grain, as: G
  alias Grain.Repo
  alias Grain.Tasks, as: Gt

  def run() do
    {:ok, _} = Application.ensure_all_started(:grain)
    # {:ok, pid} = Agent.start_link(fn -> %{} end)
    #    p = Agent.get(pid, fn i -> i end)
    p = Process.get(:zeng)

    if is_nil(p) do
      Process.put(:zeng, %{})
      u1(b())
    else
      IO.puts(123)
      IO.inspect(p)

      if length(Map.values(p)) != 0 do
        Enum.each(Map.values(p), fn i ->
          if is_pid(i) do
            if Process.alive?(i) do
              IO.puts("#{i} is alive")
            else
              u1(b())
            end
          else
            IO.puts("#{i} is not a pid")
          end
        end)
      else
        u1(b())
      end
    end

    #    if Map.equal?(p, %{}) do
    #      u1(b(), pid)
    #    else
    #      IO.inspect(p)
    #    end
  end

  def a(dqqq) do
    uu = "http://123.127.88.167:8888/tradeClient/observe/requestList?specialNo="
    u = uu <> dqqq

    HTTPoison.get!(u).body |> Jason.decode!()
  end

  def s(d) do
    x = d["requestAlias"]

    y =
      if String.length(x) <= 12 || String.length(x) == 13 || String.length(x) == 15 do
        # y = x |> String.slice(0, 4) |> String.to_integer()
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
      trantype: "拍卖"
    }

    changeset = G.changeset(%G{}, attr)
    Repo.insert(changeset)
  end

  def b do
    uuu = "http://123.127.88.167:8888/tradeClient/observe/specialList"
    HTTPoison.get!(uuu).body |> Jason.decode!()
  end

  def j(j) do
    if String.to_integer(j["remainSeconds"]) <= 3 do
      g =
        G
        |> Ecto.Query.where([g], g.mark_number == ^j["requestAlias"])
        |> limit(1)
        |> Grain.Repo.all()
        |> length

      if g == 0 do
        s(j)
      end
    end
  end

  def d(dd, y) do
    if dd["status"] == "no" || dd["status"] == "end" do
      IO.puts("The status is no or end")
    else
      grain(y)
    end
  end

  def grain(y) do
    dd = a(y)

    if dd["status"] == "yes" do
      Enum.each(dd["rows"], fn jj ->
        if String.match?(jj["varietyName"], ~r/玉米/) || String.match?(jj["varietyName"], ~r/麦/) ||
             String.match?(jj["varietyName"], ~r/油/) do
          IO.puts("It is a #{jj["varietyName"]}")
        else
          j(jj)
        end
      end)

      grain(y)
    else
      d(dd, y)
    end
  end

  def u1(b) when b != [] do
    #    qww = Agent.get(pid, & &1)
    qww = Process.get(:zeng)

    Enum.each(b, fn x ->
      y = x["specialNo"]

      if Map.has_key?(qww, y) do
        if !Process.alive?(qww[y]) do
          #          Agent.update(pid, fn j -> Map.delete(j, y) end)
          Map.delete(qww, y)
        end
      else
        i = spawn(Gt, :grain, [y])

        #        Agent.update(pid, fn j -> Map.put(j, y, i) end)
        qwww = Map.put(qww, y, i)
        Process.put(:zeng, qwww)
      end
    end)

    u1(b())
  end

  def u1(b) when b == [] do
    IO.puts("结束")
    #    Agent.update(pid, fn i -> Map.drop(i, Map.keys(i)) end)
    # Process.delete(:zeng)
    #    IO.inspect(pid)
  end
end
