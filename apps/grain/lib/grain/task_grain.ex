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

    trantype =
      if Regex.match?(~r/采购/, dd) do
        "采购"
      else
        "拍卖"
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
      if d["currentPrice"] == "0" do
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
      trantype: trantype
    }

    rows = Agent.get(pid, & &1)
    IO.inspect(rows)

    if Enum.member?(rows, attr) do
      if d["remainSeconds"] == "0" do
        Agent.update(pid, fn rows ->
          Enum.each(rows, fn row ->
            if row.mark_number == attr.mark_number do
              Map.put(row, :latest_price, attr.latest_price)
            end
          end)
        end)
      end

      IO.puts(true)
    else
      if rows != [] do
        Enum.each(rows, fn row ->
          if row.mark_number! = attr.mark_number do
            Agent.update(pid, &[attr | &1])
          end
        end)
      else
        Agent.update(pid, &[attr | &1])
      end
    end
  end

  def j(j, d, pid) do
    case String.to_integer(j["remainSeconds"]) do
      x when x > 3 ->
        rows = Agent.get(pid, & &1)

        if !Enum.empty?(rows) do
          Enum.each(rows, fn attr ->
            IO.inspect(attr)
            changeset = G.changeset(%G{}, attr)
            Repo.insert(changeset)
            Agent.update(pid, &Enum.drop_every(&1, 1))
          end)
        end

        Process.sleep(x * 1000 - 3000)
        IO.puts(x * 1000 - 3000)
        grain(d["specialNo"], pid)

      x when x <= 3 ->
        s(j, d["specialName"], pid)
    end
  end

  def grain(y, pid) do
    dd = a(y)

    case dd["status"] do
      "yes" ->
        Enum.each(dd["rows"], fn jj ->
          if !(String.match?(jj["varietyName"], ~r/玉米/) ||
                 String.match?(jj["varietyName"], ~r/麦/) ||
                 String.match?(jj["varietyName"], ~r/油/) ||
                 String.match?(jj["varietyName"], ~r/豆/)) do
            j(jj, dd, pid)
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
