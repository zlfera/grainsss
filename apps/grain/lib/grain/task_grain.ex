defmodule Grain.TaskGrain do
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
  end

  def s(d, dd, pid) do
    x = d["requestAlias"]

    trantype =
      case Regex.match?(~r/采购/, dd) do
        true -> "采购"
        false -> "拍卖"
      end

    {i, j} = {String.length(x) <= 14, ~r/^\d+/ |> Regex.run(x)}

    y =
      case {i, j} do
        {true, nil} -> "00"
        {true, _} -> List.to_string(j)
        {false, _} -> String.slice(x, 11, 2)
      end

    status_name =
      case d["currentPrice"] do
        "0" -> "流拍"
        _ -> "成交"
      end

    attr = %{
      market_name: "guojia",
      mark_number: d["requestAlias"],
      request_no: d["requestNo"],
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

    {i, j, k} = {
      Enum.empty?(rows),
      Enum.find_value(rows, false, &(&1.mark_number == attr.mark_number)),
      d["remainSeconds"] == "0"
    }

    case {i, j, k} do
      {true, _, _} ->
        Agent.update(pid, &[attr | &1])

      {false, true, true} ->
        Agent.update(pid, fn rows ->
          index = Enum.find_index(rows, &(&1.mark_number == attr.mark_number))
          List.update_at(rows, index, &Map.put(&1, :latest_price, attr.latest_price))
        end)

      {false, _, _} ->
        Agent.update(pid, &[attr | &1])
    end
  end

  def j(j, d, pid) do
    x = String.to_integer(j["remainSeconds"])

    cond do
      x > 2 ->
        rows = Agent.get(pid, & &1)

        if !Enum.empty?(rows) do
          Enum.each(rows, fn attr ->
            changeset = G.changeset(%G{}, attr)
            Repo.insert(changeset)
            Agent.update(pid, &Enum.drop_every(&1, 1))
          end)
        end

        Process.sleep(x * 1000 - 2000)
        grain(d["specialNo"], pid)

      x <= 2 ->
        s(j, d["specialName"], pid)
    end
  end

  def grain(y, pid) do
    dd = a(y)

    i = dd["status"]

    cond do
      "yes" == i ->
        Enum.each(dd["rows"], fn jj ->
          if !String.match?(jj["varietyName"], ~r/玉米|麦|油|豆|肉/) do
            j(jj, dd, pid)
          end
        end)

        grain(y, pid)

      "end" == i || "no" == i ->
        rows = Agent.get(pid, & &1)

        if !Enum.empty?(rows) do
          Enum.each(rows, fn attr ->
            changeset = G.changeset(%G{}, attr)
            Repo.insert(changeset)
            Agent.update(pid, &Enum.drop_every(&1, 1))
          end)
        end

      true ->
        Process.sleep(5000)
        grain(y, pid)
    end
  end
end
