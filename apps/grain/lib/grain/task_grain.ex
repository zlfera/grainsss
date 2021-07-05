defmodule Grain.TaskGrain do
  alias Grain.Grains.Grain, as: G
  alias Grain.Repo

  def get_year(request_no, t) do
    ff =
      if t == :u do
        "G"
      else
        "S"
      end

    params = [
      params: %{
        param:
          Jason.encode!(%{
            m: "tradeCenterPlanDetailInfo",
            requestNo: request_no,
            flag: ff
          })
      }
    ]

    get_data =
      HTTPoison.request(:post, "http://www.grainmarket.com.cn/centerweb/getData", "", [], params)

    case get_data do
      {:ok, get_data} ->
        get_data.body
        |> Jason.decode!()
        |> Map.get("data")

      _ ->
        get_year(request_no, t)
    end
  end

  def a(dqqq) do
    u = "http://36.33.35.40:8888/tradeClient/observe/requestList?specialNo="
    uu = "http://60.173.214.163:5188/observe/requestList?specialNo="

    u =
      case HTTPoison.get(u <> dqqq) do
        {:ok, url} ->
          url.body |> Jason.decode!()

        _ ->
          a(dqqq)
      end

    uu =
      case HTTPoison.get(uu <> dqqq) do
        {:ok, url} ->
          url.body |> Jason.decode!()

        _ ->
          a(dqqq)
      end

    cond do
      u["status"] == "end" and uu["status"] == "end" ->
        IO.puts("拍卖已经结束")
        {:u, u}

      u["status"] != "end" ->
        {:u, u}

      uu["status"] != "end" ->
        {:uu, uu}
    end
  end

  def s(d, pid) do
    rows = Agent.get(pid, & &1)

    j = Enum.find_value(rows, false, fn x -> x == d["requestNo"] end)

    case j do
      false ->
        Agent.update(pid, &[d["requestNo"] | &1])

      true ->
        nil
    end
  end

  def j(j, pid) do
    s(j, pid)
  end

  def grain(y, pid) do
    {t, dd} = a(y)

    case dd["status"] do
      "yes" ->
        Enum.each(dd["rows"], fn jj ->
          if !String.match?(jj["varietyName"], ~r/玉米|麦|油|豆|肉/) do
            j(jj, pid)
          end
        end)

        list_rows = Enum.sort(dd["rows"], &(&1["remainSeconds"] >= &2["remainSeconds"]))
        sleep_time = List.first(list_rows)["remainSeconds"] |> String.to_integer()

        Process.sleep(sleep_time)
        grain(y, pid)

      x when x in ["end", "no"] ->
        Process.sleep(2000)
        pid_map = Agent.get(pid, & &1)

        if !Enum.empty?(pid_map) do
          push(t, pid)
        end

        IO.puts("任务结束")

      "interval" ->
        push(t, pid)
        Process.sleep(5000)
        grain(y, pid)

      _ ->
        Process.sleep(1000)
        grain(y, pid)
    end
  end

  def push(t, pid) do
    rows = Agent.get(pid, & &1) |> Enum.reverse()

    if !Enum.empty?(rows) do
      Enum.each(rows, fn attr ->
        get_data = get_year(attr, t)

        bs =
          case get_data["bs"] do
            x when x in ["s", "S"] ->
              "拍卖"

            _ ->
              "采购"
          end

        storage_depot_name =
          case bs do
            "拍卖" ->
              get_data["storageDepotName"]

            _ ->
              get_data["storageDepotName"]
          end

        current_price =
          if get_data["currentPrice"] == "" do
            "0"
          else
            get_data["currentPrice"]
          end

        attr = %{
          market_name: get_data["marketName"],
          mark_number: get_data["requestAlias"],
          request_no: get_data["requestNo"],
          year: get_data["prodDate"],
          variety: get_data["varietyName"],
          grade: get_data["gradeName"],
          trade_amount: get_data["num"],
          starting_price: get_data["basePrice"],
          latest_price: current_price,
          address: get_data["buyDepotName"],
          status: get_data["statusName"],
          trantype: bs,
          store_no: get_data["storeNo"],
          storage_depot_name: storage_depot_name
        }

        changeset = G.changeset(%G{}, attr)
        Repo.insert(changeset)
      end)

      Agent.update(pid, &Enum.drop_every(&1, 1))
    end
  end
end
