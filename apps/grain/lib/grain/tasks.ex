defmodule Grain.Tasks do
  @moduledoc false
  alias Grain.Grains.Grain, as: G
  alias Grain.Repo
  alias Grain.Tasks, as: Gt

  def run() do
    {:ok, _} = Application.ensure_all_started(:grain)
    {:ok, pid} = Agent.start_link(fn -> %{} end)
    u1(b(), pid)
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
    :timer.sleep(10000)
    uuu = "http://123.127.88.167:8888/tradeClient/observe/specialList"
    HTTPoison.get!(uuu).body |> Jason.decode!()
  end

  def j(j) do
    if String.to_integer(j["remainSeconds"]) <= 2 do
      s(j)
    end
  end

  def d(dd, y, pid) do
    if dd["status"] == "no" || dd["status"] == "end" do
      "over"
    else
      grain(y, pid)
    end
  end

  def grain(y, pid) do
    dd = a(y)

    if dd["status"] == "yes" do
      Enum.each(dd["rows"], fn jj ->
        j(jj)
      end)

      grain(y, pid)
    else
      d(dd, y, pid)
    end
  end

  def u1(b, pid) when b != [] do
    qww = Agent.get(pid, & &1)

    Enum.each(b, fn x ->
      y = x["specialNo"]

      if Map.has_key?(qww, y) do
        unless Process.alive?(qww[y]) do
          Agent.update(pid, fn j -> Map.delete(j, y) end)
        end
      else
        i = spawn(Gt, :grain, [y, pid])

        Agent.update(pid, fn j -> Map.put(j, y, i) end)
      end
    end)

    u1(b, pid)
  end

  def u1(b, pid) when b == [] do
    IO.puts("结束")
  end
end
