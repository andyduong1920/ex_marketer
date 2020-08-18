![CI](https://github.com/anduonghien/ex_marketer/workflows/CI/badge.svg?branch=development)

## Setup

1/ Install Docker

2/ Install Elixir and Erlang

3/ Fetch dependecies

```bash
mix deps.get
```

4/ Boostrap the environment

```bash
bin/envsetup.sh
```

## Start the Phoenix server

```bash
mix phx.server
```

The Web app will run on `localhost:4000`

## Live version

https://ex-marketer.herokuapp.com/

## Test

1/ Install `chromedriver`

```bash
brew cask install chromedriver
```

2/ Running test

```bash
mix test # with Chrome Headless browser

CHROME_HEADLESS=false mix test # with Chrome browser
```
