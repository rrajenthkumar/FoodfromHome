defmodule FoodFromHomeWeb.SellerJSON do
  alias FoodFromHome.Sellers.Seller

  @doc """
  Renders a list of sellers.
  """
  def index(%{sellers: sellers}) do
    %{data: for(seller <- sellers, do: data(seller))}
  end

  @doc """
  Renders a single seller.
  """
  def show(%{seller: seller}) do
    %{data: data(seller)}
  end

  defp data(%Seller{} = seller) do
    %{
      id: seller.id,
      illustration: seller.illustration,
      introduction: seller.introduction,
      tax_id: seller.tax_id
    }
  end
end
