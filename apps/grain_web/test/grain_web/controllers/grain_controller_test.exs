defmodule GrainWeb.GrainControllerTest do
  use GrainWeb.ConnCase

  alias Grain.Grains

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:grain) do
    {:ok, grain} = Grains.create_grain(@create_attrs)
    grain
  end

  describe "index" do
    test "lists all grains", %{conn: conn} do
      conn = get(conn, Routes.grain_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Grains"
    end
  end

  describe "new grain" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.grain_path(conn, :new))
      assert html_response(conn, 200) =~ "New Grain"
    end
  end

  describe "create grain" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.grain_path(conn, :create), grain: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.grain_path(conn, :show, id)

      conn = get(conn, Routes.grain_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Grain"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.grain_path(conn, :create), grain: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Grain"
    end
  end

  describe "edit grain" do
    setup [:create_grain]

    test "renders form for editing chosen grain", %{conn: conn, grain: grain} do
      conn = get(conn, Routes.grain_path(conn, :edit, grain))
      assert html_response(conn, 200) =~ "Edit Grain"
    end
  end

  describe "update grain" do
    setup [:create_grain]

    test "redirects when data is valid", %{conn: conn, grain: grain} do
      conn = put(conn, Routes.grain_path(conn, :update, grain), grain: @update_attrs)
      assert redirected_to(conn) == Routes.grain_path(conn, :show, grain)

      conn = get(conn, Routes.grain_path(conn, :show, grain))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, grain: grain} do
      conn = put(conn, Routes.grain_path(conn, :update, grain), grain: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Grain"
    end
  end

  describe "delete grain" do
    setup [:create_grain]

    test "deletes chosen grain", %{conn: conn, grain: grain} do
      conn = delete(conn, Routes.grain_path(conn, :delete, grain))
      assert redirected_to(conn) == Routes.grain_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.grain_path(conn, :show, grain))
      end
    end
  end

  defp create_grain(_) do
    grain = fixture(:grain)
    {:ok, grain: grain}
  end
end
