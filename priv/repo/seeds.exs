coins = [
  %{name: "Bitcoin", ticker: "BTC-USD", interval: 15_000},
  %{name: "Ethereum", ticker: "ETH-USD", interval: 15_000},
  %{name: "Dogecoin", ticker: "DOGE-USD", interval: 15_000}
]

for coin <- coins do
  Crypto.Currencies.create_coin(coin)
end
