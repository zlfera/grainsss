defmodule Grain.TaskGrain do
  alias Grain.Grains.Grain, as: G
  alias Grain.Repo

  # def get_list(special_no, id \\ "1", size \\ "10") do
  #  params = [
  #    params: %{
  #      param:
  #        Jason.encode!(%{
  #          indexid: id,
  #          pagesize: size,
  #          m: "tradeCenterPlanList",
  #          specialNo: special_no,
  #          flag: "G"
  #        })
  #    }
  #  ]

  #  get_data =
  #    HTTPoison.request!(:post, "http://www.grainmarket.com.cn/centerweb/getData", "", [], params).body
  #    |> Jason.decode!()

  #  get_data
  # end

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
        get_data.body
        |> Jason.decode!()
        |> Map.get("data")

      _ ->
        get_year(request_no)
    end
  end

  def a(dqqq) do
    uu = "http://123.127.88.167:8888/tradeClient/observe/requestList?specialNo="
    u = uu <> dqqq

    case HTTPoison.get(u) do
      {:ok, url} ->
        url.body |> Jason.decode!()

      _ ->
        a(dqqq)
    end
  end

  def s(d, pid) do
    attr = d["requestNo"]

    rows = Agent.get(pid, & &1)

    j = Enum.find_value(rows, false, fn x -> x == attr end)

    case j do
      false ->
        Agent.update(pid, &[attr | &1])

      true ->
        nil
    end
  end

  def j(j, pid) do
    s(j, pid)
  end

  def grain(y, pid) do
    dd = a(y)

    case dd["status"] do
      "yes" ->
        Enum.each(dd["rows"], fn jj ->
          if !String.match?(jj["varietyName"], ~r/玉米|麦|油|豆|肉/) do
            j(jj, pid)
          end
        end)

        Process.sleep(2000)
        grain(y, pid)

      x when x in ["end", "no"] ->
        "ren wu jie shu"

      "interval" ->
        push(pid)
        Process.sleep(5000)
        grain(y, pid)

      _ ->
        Process.sleep(1000)
        grain(y, pid)
    end
  end

  def push(pid) do
    rows = Agent.get(pid, & &1)

    if !Enum.empty?(rows) do
      Enum.each(rows, fn attr ->
        get_data = get_year(attr)

        bs =
          case get_data["bs"] do
            x when x in ["s", "S"] ->
              "拍卖"

            _ ->
              "采购"
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
          storage_depot_name: get_data["storageDepotName"]
        }

        changeset = G.changeset(%G{}, attr)
        zzz = Repo.insert(changeset)
        IO.inspect(zzz)
      end)

      Agent.update(pid, &Enum.drop_every(&1, 1))
    end
  end
end
