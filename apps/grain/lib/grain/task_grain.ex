defmodule Grain.TaskGrain do
  alias Grain.Grains.Grain, as: G
  alias Grain.Repo

  def get_list(special_no, id \\ "1", size \\ "10") do
    params = [
      params: %{
        param:
          Jason.encode!(%{
            indexid: id,
            pagesize: size,
            m: "tradeCenterPlanList",
            specialNo: special_no,
            flag: "G"
          })
      }
    ]

    get_data =
      HTTPoison.request!(:post, "http://www.grainmarket.com.cn/centerweb/getData", "", [], params).body
      |> Jason.decode!()

    # get_data["data"]["prodDate"]
    get_data
  end

  def get_year(request_no) do
    params = [
      params: %{
        param:
          Jason.encode!(%{
            m: "tradeCenterPlanDetailInfo",
            requestNo: request_no,
            flag: "G"
          })
      }
    ]

    {ok, get_data} =
      HTTPoison.request(:post, "http://www.grainmarket.com.cn/centerweb/getData", "", [], params)

    if ok == :ok do
      get_data =
        get_data.body
        |> Jason.decode!()
        |> Map.get("data")

      year = get_data["prodDate"]
      store_no = get_data["storeNo"]
      storage_depot_name = get_data["storageDepotName"]
      {year, store_no, storage_depot_name}
    else
      {"00", "00", "00"}
    end
  end

  def a(dqqq) do
    uu = "http://123.127.88.167:8888/tradeClient/observe/requestList?specialNo="
    u = uu <> dqqq

    if {:ok, url} = HTTPoison.get(u) do
      url.body |> Jason.decode!()
    else
      a(dqqq)
    end
  end

  def s(d, dd, pid) do
    trantype =
      case Regex.match?(~r/采购/, dd) do
        true -> "采购"
        false -> "拍卖"
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
      year: "00",
      variety: d["varietyName"],
      grade: d["gradeName"],
      trade_amount: d["num"],
      starting_price: d["basePrice"],
      latest_price: d["currentPrice"],
      address: d["requestBuyDepotName"],
      status: status_name,
      trantype: trantype,
      store_no: "00",
      storage_depot_name: "00"
    }

    rows = Agent.get(pid, & &1)

    i = Enum.empty?(rows)
    j = Enum.find_value(rows, false, &(&1.mark_number == attr.mark_number))
    row = Enum.find(rows, &(&1.mark_number == attr.mark_number))

    case {i, j, trantype} do
      {true, _, _} ->
        Agent.update(pid, &[attr | &1])

      {false, false, _} ->
        Agent.update(pid, &[attr | &1])

      {false, true, "拍卖"} ->
        if String.to_integer(attr.latest_price) > String.to_integer(row.latest_price) do
          Agent.update(pid, fn rows ->
            index = Enum.find_index(rows, &(&1.mark_number == attr.mark_number))
            List.update_at(rows, index, &Map.put(&1, :latest_price, attr.latest_price))
          end)
        end

      {false, true, "采购"} ->
        if String.to_integer(attr.latest_price) < String.to_integer(row.latest_price) do
          Agent.update(pid, fn rows ->
            index = Enum.find_index(rows, &(&1.mark_number == attr.mark_number))
            List.update_at(rows, index, &Map.put(&1, :latest_price, attr.latest_price))
          end)
        end
    end
  end

  def j(j, d, pid) do
    x = String.to_integer(j["remainSeconds"])

    cond do
      x > 3 ->
        task_time = Task.async(Process, :sleep, [x * 1000 - 3000])
        {year, store_no, storage_depot_name} = get_year(j["requestNo"])
        rows = Agent.get(pid, & &1)

        if !Enum.empty?(rows) do
          Enum.each(rows, fn attr ->
            attr = Map.put(attr, :year, year)
            attr = Map.put(attr, :store_no, store_no)
            attr = Map.put(attr, :storage_depot_name, storage_depot_name)
            changeset = G.changeset(%G{}, attr)
            Repo.insert(changeset)
            Agent.update(pid, &Enum.drop_every(&1, 1))
          end)
        end

        Task.await(task_time, x * 1000)
        grain(d["specialNo"], pid)

      x <= 3 ->
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
