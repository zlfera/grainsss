defmodule GrainWeb.GrainView do
  use GrainWeb, :view

  def fenye(pid, params) do
    fenye =
      if params["fenye"] in ["", nil] do
        0
      else
        params["fenye"] |> String.to_integer()
      end

    Agent.update(pid, fn x -> x + fenye end)
    Agent.get(pid, fn x -> x end)
  end

  def fenyeend(params) do
    if params["fenye"] in ["", nil] do
      0
    else
      params["fenye"] |> String.to_integer()
    end

    # Agent.get(pid, fn x -> x end)
  end

  def fenyeurl(fenye, params) do
    Agent.update(fenye, fn x -> x + 10 end)
    f = Agent.get(fenye, fn x -> x end)

    "/grain?page=#{params["page"]}&city1=#{params["city1"]}&city2=#{params["city2"]}&city3=#{
      params["city3"]
    }&year=#{params["year"]}&limit=#{params["limit"]}&fenye=#{f}"
  end

  def dizeng(pid) do
    Agent.update(pid, fn i -> i + 1 end)
    Agent.get(pid, fn i -> i end)
  end

  def page(num, params) do
    "/grain?page=#{num}&city1=#{params["city1"]}&city2=#{params["city2"]}&city3=#{params["city3"]}&year=#{
      params["year"]
    }&limit=#{params["limit"]}&fenye=#{params["fenye"]}"
  end

  def limit_num(num, params) do
    if params["limit"] == "" do
      ceil(num / 50)
    else
      ceil(num / String.to_integer(params["limit"]))
    end
  end
end
