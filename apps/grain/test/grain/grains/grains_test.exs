defmodule Grain.GrainsTest do
  use Grain.DataCase

  alias Grain.Grains

  describe "grains" do
    alias Grain.Grains.Grain

    @valid_attrs %{address: "some address", grade: "some grade", latest_price: "some latest_price", mark_number: "some mark_number", market_name: "some market_name", starting_price: "some starting_price", status: "some status", trade_amount: "some trade_amount", trantype: "some trantype", variety: "some variety", year: "some year"}
    @update_attrs %{address: "some updated address", grade: "some updated grade", latest_price: "some updated latest_price", mark_number: "some updated mark_number", market_name: "some updated market_name", starting_price: "some updated starting_price", status: "some updated status", trade_amount: "some updated trade_amount", trantype: "some updated trantype", variety: "some updated variety", year: "some updated year"}
    @invalid_attrs %{address: nil, grade: nil, latest_price: nil, mark_number: nil, market_name: nil, starting_price: nil, status: nil, trade_amount: nil, trantype: nil, variety: nil, year: nil}

    def grain_fixture(attrs \\ %{}) do
      {:ok, grain} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Grains.create_grain()

      grain
    end

    test "list_grains/0 returns all grains" do
      grain = grain_fixture()
      assert Grains.list_grains() == [grain]
    end

    test "get_grain!/1 returns the grain with given id" do
      grain = grain_fixture()
      assert Grains.get_grain!(grain.id) == grain
    end

    test "create_grain/1 with valid data creates a grain" do
      assert {:ok, %Grain{} = grain} = Grains.create_grain(@valid_attrs)
      assert grain.address == "some address"
      assert grain.grade == "some grade"
      assert grain.latest_price == "some latest_price"
      assert grain.mark_number == "some mark_number"
      assert grain.market_name == "some market_name"
      assert grain.starting_price == "some starting_price"
      assert grain.status == "some status"
      assert grain.trade_amount == "some trade_amount"
      assert grain.trantype == "some trantype"
      assert grain.variety == "some variety"
      assert grain.year == "some year"
    end

    test "create_grain/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Grains.create_grain(@invalid_attrs)
    end

    test "update_grain/2 with valid data updates the grain" do
      grain = grain_fixture()
      assert {:ok, %Grain{} = grain} = Grains.update_grain(grain, @update_attrs)

      
      assert grain.address == "some updated address"
      assert grain.grade == "some updated grade"
      assert grain.latest_price == "some updated latest_price"
      assert grain.mark_number == "some updated mark_number"
      assert grain.market_name == "some updated market_name"
      assert grain.starting_price == "some updated starting_price"
      assert grain.status == "some updated status"
      assert grain.trade_amount == "some updated trade_amount"
      assert grain.trantype == "some updated trantype"
      assert grain.variety == "some updated variety"
      assert grain.year == "some updated year"
    end

    test "update_grain/2 with invalid data returns error changeset" do
      grain = grain_fixture()
      assert {:error, %Ecto.Changeset{}} = Grains.update_grain(grain, @invalid_attrs)
      assert grain == Grains.get_grain!(grain.id)
    end

    test "delete_grain/1 deletes the grain" do
      grain = grain_fixture()
      assert {:ok, %Grain{}} = Grains.delete_grain(grain)
      assert_raise Ecto.NoResultsError, fn -> Grains.get_grain!(grain.id) end
    end

    test "change_grain/1 returns a grain changeset" do
      grain = grain_fixture()
      assert %Ecto.Changeset{} = Grains.change_grain(grain)
    end
  end
end
