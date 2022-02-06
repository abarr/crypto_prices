coins = [
  %{name: "Bitcoin", ticker: "BTC-USD"},
  %{name: "Ethereum", ticker: "ETH-USD"},
  %{name: "Dogecoin", ticker: "DOGE-USD"}
]

for coin <- coins do
  Crypto.Coins.create_coin(coin)
end
