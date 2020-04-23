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

    get_data =
      HTTPoison.request(:post, "http://www.grainmarket.com.cn/centerweb/getData", "", [], params)

    case get_data do
      {:ok, get_data} ->
        get_data =
          get_data.body
          |> Jason.decode!()
          |> Map.get("data")

        year = get_data["prodDate"]
        store_no = get_data["storeNo"]
        storage_depot_name = get_data["storageDepotName"]
        {year, store_no, storage_depot_name}

      _ ->
        get_year(request_no)
        # {"00", "00", "00"}
    end
  end

  def a(dqqq) do
    uu = "http://123.127.88.167:8888/tradeClient/observe/requestList?specialNo="
    u = uu <> dqqq

    case HTTPoison.get(u) do
      {:ok, url} ->
        url.body |> Jason.decode!()

      {:error, _} ->
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
      year: "0",
      variety: d["varietyName"],
      grade: d["gradeName"],
      trade_amount: d["num"],
      starting_price: d["basePrice"],
      latest_price: d["currentPrice"],
      address: d["requestBuyDepotName"],
      status: status_name,
      trantype: trantype,
      store_no: "0",
      storage_depot_name: "0"
    }

    rows = Agent.get(pid, & &1)

    j = Enum.find_value(rows, false, &(&1.mark_number == attr.mark_number))

    case {j, trantype} do
      {false, _} ->
        Agent.update(pid, &[attr | &1])

      {true, "拍卖"} ->
        row = Enum.find(rows, &(&1.mark_number == attr.mark_number))

        if String.to_integer(attr.latest_price) > String.to_integer(row.latest_price) do
          Agent.update(pid, fn rows ->
            index = Enum.find_index(rows, &(&1.mark_number == attr.mark_number))
            List.update_at(rows, index, &Map.put(&1, :latest_price, attr.latest_price))
          end)
        end

      {true, "采购"} ->
        row = Enum.find(rows, &(&1.mark_number == attr.mark_number))

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
      x > 2 ->
        Process.sleep(x * 1000 - 2000)
        grain(d["specialNo"], pid)

      x <= 2 ->
        s(j, d["specialName"], pid)
    end
  end

  def grain(y, pid) do
    dd = a(y)

    i = dd["status"]
    IO.inspect(i)

    cond do
      "yes" == i ->
        Enum.each(dd["rows"], fn jj ->
          if !String.match?(jj["varietyName"], ~r/玉米|麦|油|豆|肉/) do
            j(jj, dd, pid)
          end
        end)

        grain(y, pid)

      "end" == i || "no" == i ->
        "ren wu jie shu"

      "intervar" == i ->
        push(pid)
        Process.sleep(5000)
        grain(y, pid)

      true ->
        # rows = Agent.get(pid, & &1)

        # if !Enum.empty?(rows) do
        #  Enum.each(rows, fn attr ->
        #    {year, store_no, storage_depot_name} = get_year(attr[:request_no])

        #    attr =
        #      attr
        #      |> Map.put(:year, year)
        #      |> Map.put(:store_no, store_no)
        #      |> Map.put(:storage_depot_name, storage_depot_name)

        #    changeset = G.changeset(%G{}, attr)
        #    Repo.insert(changeset)
        #  end)

        #  Agent.update(pid, &Enum.drop_every(&1, 1))
        # end

        # spawn(Grain.TaskGrain, :push, [pid])
        grain(y, pid)
    end
  end

  def push(pid) do
    rows = Agent.get(pid, & &1)

    if !Enum.empty?(rows) do
      Enum.each(rows, fn attr ->
        {year, store_no, storage_depot_name} = get_year(attr[:request_no])

        attr =
          attr
          |> Map.put(:year, year)
          |> Map.put(:store_no, store_no)
          |> Map.put(:storage_depot_name, storage_depot_name)

        changeset = G.changeset(%G{}, attr)
        zzz = Repo.insert(changeset)
        IO.inspect(zzz)
      end)

      Agent.update(pid, &Enum.drop_every(&1, 1))
    end
  end
end
