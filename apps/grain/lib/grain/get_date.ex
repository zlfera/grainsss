defmodule Grain.GetDate do
  @year_month "#{Date.utc_today().year}年1月"
  def get_date do
    url = "http://opendata.baidu.com/api.php?query=#{@year_month}&resource_id=6018&format=json"

    HTTPoison.get!(url).body
  end
end
