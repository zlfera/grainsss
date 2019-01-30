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

  def s(d, dd) do
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

  def j(j, d) do
    case String.to_integer(j["remainSeconds"]) do
      x when x == 30 ->
        Process.sleep(27000)
        IO.puts("27")

      x when x == 29 ->
        Process.sleep(26000)
        IO.puts("29")

      x when x == 28 ->
        Process.sleep(25000)
        IO.puts("22")

      x when x == 27 ->
        Process.sleep(24000)
        IO.puts("27")

      x when x == 26 ->
        Process.sleep(23000)
        IO.puts("26")

      x when x == 25 ->
        Process.sleep(22000)
        IO.puts("25")

      x when x == 24 ->
        Process.sleep(21000)
        IO.puts("24")

      x when x == 23 ->
        Process.sleep(20000)
        IO.puts("23")

      x when x == 22 ->
        Process.sleep(19000)
        IO.puts("22")

      x when x == 21 ->
        Process.sleep(18000)
        IO.puts("21")

      x when x == 20 ->
        Process.sleep(17000)
        IO.puts("20")

      x when x == 19 ->
        Process.sleep(16000)
        IO.puts("19")

      x when x == 18 ->
        Process.sleep(15000)
        IO.puts("18")

      x when x == 17 ->
        Process.sleep(14000)
        IO.puts("17")

      x when x == 16 ->
        Process.sleep(13000)
        IO.puts("16")

      x when x == 15 ->
        Process.sleep(12000)
        IO.puts("15")

      x when x == 14 ->
        Process.sleep(11000)
        IO.puts("14")

      x when x == 13 ->
        Process.sleep(10000)
        IO.puts("13")

      x when x == 12 ->
        Process.sleep(9000)
        IO.puts("12")

      x when x == 11 ->
        Process.sleep(8000)
        IO.puts("11")

      x when x == 10 ->
        Process.sleep(7000)
        IO.puts("10")

      x when x == 9 ->
        Process.sleep(6000)
        IO.puts("9")

      x when x == 8 ->
        Process.sleep(5000)
        IO.puts("8")

      x when x == 7 ->
        Process.sleep(4000)
        IO.puts("7")

      x when x == 6 ->
        Process.sleep(3000)
        IO.puts("6")

      x when x == 5 ->
        Process.sleep(2000)
        IO.puts("5")

      x when x == 4 ->
        Process.sleep(1000)
        IO.puts("4")

      x when x <= 3 ->
        g =
          G
          |> where([g], g.mark_number == ^j["requestAlias"])
          |> limit(1)
          |> Repo.all()

        if g == [] do
          s(j, d)
        end
    end
  end

  def grain(y) do
    dd = a(y)

    case dd["status"] do
      "yes" ->
        Enum.each(dd["rows"], fn jj ->
          if String.match?(jj["varietyName"], ~r/玉米/) || String.match?(jj["varietyName"], ~r/麦/) ||
               String.match?(jj["varietyName"], ~r/油/) || String.match?(jj["varietyName"], ~r/豆/) do
          else
            j(jj, dd["specialName"])
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
end
