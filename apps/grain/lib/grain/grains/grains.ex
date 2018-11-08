defmodule Grain.Grains do
  @moduledoc """
  The Grains context.
  """

  import Ecto.Query, warn: false
  alias Grain.Repo

  alias Grain.Grains.Grain, as: G

  @doc """
  Returns the list of grains.

  ## Examples

      iex> list_grains()
      [%Grain{}, ...]

  """
  def list_grains do
    Repo.all(G)
  end

  @doc """
  Gets a single grain.

  Raises `Ecto.NoResultsError` if the Grain does not exist.

  ## Examples

      iex> get_grain!(123)
      %Grain{}

      iex> get_grain!(456)
      ** (Ecto.NoResultsError)

  """
  def get_grain!(id), do: Repo.get!(G, id)

  @doc """
  Creates a grain.

  ## Examples

      iex> create_grain(%{field: value})
      {:ok, %Grain{}}

      iex> create_grain(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_grain(attrs \\ %{}) do
    %G{}
    |> G.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a grain.

  ## Examples

      iex> update_grain(grain, %{field: new_value})
      {:ok, %Grain{}}

      iex> update_grain(grain, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_grain(%G{} = grain, attrs) do
    grain
    |> G.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Grain.

  ## Examples

      iex> delete_grain(grain)
      {:ok, %Grain{}}

      iex> delete_grain(grain)
      {:error, %Ecto.Changeset{}}

  """
  def delete_grain(%G{} = grain) do
    Repo.delete(grain)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking grain changes.

  ## Examples

      iex> change_grain(grain)
      %Ecto.Changeset{source: %Grain{}}

  """
  def change_grain(%G{} = grain) do
    G.changeset(grain, %{})
  end
end
