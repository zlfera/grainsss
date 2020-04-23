defmodule GrainWeb.GrainView do
  use GrainWeb, :view
  import Phoenix.HTML.Tag

  def the_begin_page(page_num) do
    page_num
  end

  def limit(params) do
    if params["limit"] in ["", nil] do
      100
    else
      String.to_integer(params["limit"])
    end
  end

  def url(num, params) do
    "/grains?page=#{num}&limit=#{params["limit"]}&city1=#{params["city1"]}&city2=#{
      params["city2"]
    }&city3=#{params["city3"]}&year=#{params["year"]}&page_num=#{params["page_num"]}"
  end

  def the_up_page(params) do
    page_num = String.to_integer(params["page_num"])

    "/grains?page=#{page_num - 10}&limit=#{params["limit"]}&city1=#{params["city1"]}&city2=#{
      params["city2"]
    }&city3=#{params["city3"]}&year=#{params["year"]}&page_num=#{page_num - 10}"
  end

  def the_next_page(page_num, params) do
    "/grains?page=#{page_num + 10}&limit=#{params["limit"]}&city1=#{params["city1"]}&city2=#{
      params["city2"]
    }&city3=#{params["city3"]}&year=#{params["year"]}&page_num=#{page_num + 10}"
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

  def dizeng(pid) do
    Agent.update(pid, fn i -> i + 1 end)
    Agent.get(pid, fn i -> i end)
  end

  def limit_num(num, params) do
    if params["limit"] == "" do
      ceil(num / 100)
    else
      ceil(num / String.to_integer(params["limit"]))
    end
  end
end
