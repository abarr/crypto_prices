# Take-home Assignment

![image](https://user-images.githubusercontent.com/686715/133868047-ae86e0fb-7a03-4b42-9e14-6645f37fcbc1.png)

## Fullstack Senior Software Engineer

Thank you for your interest in applying to Oxygen!

We use asdf to manage deps. This is a Phoenix 1.6.0 project, using Postgres for the database.

This take-home should be completed in no more than 5 hours. In order of importance, here are
the things we are looking for:

1. Is the solution complete and functional?
2. Can the engineer describe what's going on and trade-offs made for the solution?
3. Is the code easy to understand?
4. Is the code production quality?

## Installation

```
asdf install
mix deps.get
cd assets
npm install
cd ..
iex -S mix phx.server
```

## Tasks

Crypto is a Phoenix Liveview application that keeps track of crypto
prices in real-time. All features should be built using Liveview only.

Please use the Coinbase REST API to get the prices of crypto. Use USD as the 
currency pair with the cryptocurrency. We already have schemas for `User` and `Currency`. 
Create any new schemas that you feel are necessary.

Account registration and login is already implemented.

### Task 1

Show prices in real-time for Bitcoin, Ethereum and Dogecoin.

### Task 2

Allow logged in user to favorite a crypto.

### Task 3

Show how many people in total have favorited a crypto, in real-time. We'll
test this by opening multiple browsers with signed in users and favoriting
cryptos.



