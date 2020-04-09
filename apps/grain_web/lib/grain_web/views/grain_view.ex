defmodule GrainWeb.GrainView do
  use GrainWeb, :view

  def dizeng(pid) do
    Agent.update(pid, fn i -> i + 1 end)
    Agent.get(pid, fn i -> i end)
  end

  def page(num, params) do
    "/grain?page=#{num}&city1=#{params["city1"]}&city2=#{params["city2"]}&city3=#{params["city3"]}&year=#{
      params["year"]
    }&limit=#{params["limit"]}&fenye=10"
  end

  def limit_num(num, params) do
    if params["limit"] == "" do
      ceil(num / 50)
    else
      ceil(num / String.to_integer(params["limit"]))
    end
  end
end
