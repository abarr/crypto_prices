defmodule Crypto.Currencies.Coinbase do
  @base "https://api.coinbase.com/v2/prices/"
  @types [:spot, :buy, :sell]

  def get_price(coin, type) do
    url = url(coin, type)

    case Req.get!(url).body do
      %{"data" => %{"amount" => amt}} ->
        %{current_price: amt, name: coin, priced_at: NaiveDateTime.local_now()}

      %{"errors" => [%{"message" => msg}]} ->
        {:error, msg}
    end
  end

  defp url(coin, type) when is_binary(coin) and type in @types do
    "#{@base}#{coin}/#{Atom.to_string(type)}"
  end

  defp url(_, type), do: {:error, "Price type: #{type} is unsupported"}
end
