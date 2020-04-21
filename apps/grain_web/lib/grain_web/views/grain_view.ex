defmodule GrainWeb.GrainView do
  use GrainWeb, :view
  import Phoenix.HTML.Tag

  def the_next_page(pid_num) do
    Agent.get(pid_num, fn x -> x end)
  end

  def url(num, params) do
    "/grains?page=#{num}&limit=#{params["limit"]}&city1=#{params["city1"]}&city2=#{
      params["city2"]
    }&city3=#{params["city3"]}&year=#{params["year"]}&page_num=#{params["page_num"]}"
  end

  def the_next_page(pid_num, params) do
    Agent.update(pid_num, fn x -> x + 10 end)
    page_num = Agent.get(pid_num, fn x -> x end)

    "/grains?page=#{page_num}&limit=#{params["limit"]}&city1=#{params["city1"]}&city2=#{
      params["city2"]
    }&city3=#{params["city3"]}&year=#{params["year"]}&page_num=#{page_num}"
  end

  def name(redis) do
    a =
      if redis.store_no != nil do
        if String.match?(redis.store_no, ~r/仓/) do
          ""
        else
          "仓"
        end
      end

    raw(
      "#{redis.mark_number}</br>#{redis.storage_depot_name}</br>#{redis.store_no}#{a}</br>#{
        redis.request_no
      }"
    )
  end

  def fenye(pid, params) do
    fenye =
      if params["fenye"] in ["", nil] do
        1
      else
        params["fenye"] |> String.to_integer()
      end

    Agent.update(pid, fn x -> x + fenye end)
    Agent.get(pid, fn x -> x end)
  end

  def fenyeend(params) do
    if params["fenye"] in ["", nil] do
      1
    else
      params["fenye"] |> String.to_integer()
    end

    # Agent.get(pid, fn x -> x end)
  end

  def fenyeurl(fenye, params) do
    Agent.update(fenye, fn x -> x + 10 end)
    f = Agent.get(fenye, fn x -> x end)

    "/grains?page=#{params["page"]}&city1=#{params["city1"]}&city2=#{params["city2"]}&city3=#{
      params["city3"]
    }&year=#{params["year"]}&limit=#{params["limit"]}&fenye=#{f}"
  end

  def dizeng(pid) do
    Agent.update(pid, fn i -> i + 1 end)
    Agent.get(pid, fn i -> i end)
  end

  def page(num, params) do
    "/grains?page=#{num}&city1=#{params["city1"]}&city2=#{params["city2"]}&city3=#{
      params["city3"]
    }&year=#{params["year"]}&limit=#{params["limit"]}&fenye=#{params["fenye"]}"
  end

  def limit_num(num, params) do
    if params["limit"] == "" do
      ceil(num / 100)
    else
      ceil(num / String.to_integer(params["limit"]))
    end
  end
end
