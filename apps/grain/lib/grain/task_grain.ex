defmodule Grain.TaskGrain do
  import Ecto.Query
  alias Grain.Grains.Grain, as: G
  alias Grain.Repo

  def a(dqqq) do
    uu = "http://123.127.88.167:8888/tradeClient/observe/requestList?specialNo="
    u = uu <> dqqq
    {o, url} = HTTPoison.get(u)

    if o == :ok do
      url.body |> Jason.decode!()
    else
      a(dqqq)
    end

    # %{
    # "specialName" => "国家临储玉米竞价交易",
    # "status" => "yes",
    # "countdownStartTime" => "30",
    # "specialNo" => "1155",
    #  "section" => "201",
    # "rows" => [
    #   %{
    #     "statusId" => "8504",
    #     "gradeName" => "二等",
    #     "num" => "1020",
    #     "requestAlias" => "180607JLS2215LYM0961",
    #     "requestBuyDepotName" => "中央储备粮延吉直属库有限公司",
    #     "varietyName" => "玉米",
    #     "requestNo" => "2018053101122",
    #     "statusName" => "交易中",
    #     "currentPrice" => "0",
    #     "remainSeconds" => "30",
    #     "basePrice" => "1490"
    #   }
    # ]
    # }
  end

  def s(d, dd, pid) do
    x = d["requestAlias"]

    dd =
      if Regex.match?(~r/销售/, dd) || Regex.match?(~r/竞价/, dd) do
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

    status_name =
      if d["latest_price"] == "0" do
        "流拍"
      else
        "成交"
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
      status: status_name,
      trantype: dd
    }

    rows = Agent.get(pid, & &1)
    IO.inspect(rows)

    if Enum.member?(rows, attr.mark_number) do
      IO.puts(true)
    else
      Agent.update(pid, &[attr.mark_number | &1])
      changeset = G.changeset(%G{}, attr)
      Repo.insert(changeset)
    end
  end

  def j(j, d, y, pid) do
    case String.to_integer(j["remainSeconds"]) do
      x when x > 3 ->
        Process.sleep(x * 1000 - 3000)
        IO.puts(x * 1000 - 3000)
        grain(y, pid)

      x when x <= 3 ->
        # g =
        # G
        # |> where([g], g.mark_number == ^j["requestAlias"])
        # |> limit(1)
        # |> Repo.all()

        # if g == [] do
        s(j, d, pid)
        # end
    end
  end

  def grain(y, pid) do
    dd = a(y)

    case dd["status"] do
      "yes" ->
        Enum.each(dd["rows"], fn jj ->
          if String.match?(jj["varietyName"], ~r/玉米/) || String.match?(jj["varietyName"], ~r/麦/) ||
               String.match?(jj["varietyName"], ~r/油/) || String.match?(jj["varietyName"], ~r/豆/) do
          else
            j(jj, dd["specialName"], y, pid)
          end
        end)

        grain(y, pid)

      "end" ->
        IO.puts("The status #{y} is end")

      "no" ->
        IO.puts("The status #{y} is no")

      _ ->
        grain(y, pid)
    end
  end
end
