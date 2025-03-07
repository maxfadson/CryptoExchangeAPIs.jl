module FundingRate

export FundingRateQuery,
    FundingRateData,
    funding_rate

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Gateio
using CryptoExchangeAPIs: Maybe, APIsRequest

@enum Settle btc usdt usd

Base.@kwdef struct FundingRateQuery <: GateioPublicQuery
    contract::String
    limit::Maybe{Int64} = nothing
end

struct FundingRateData <: GateioData
    t::NanoDate
    r::Maybe{Float64}
end

"""
    funding_rate(client::GateioClient, query::FundingRateQuery)
    funding_rate(client::GateioClient = Gateio.Futures.public_client; kw...)

Funding rate history.

[`GET api/v4/futures/{settle}/funding_rate`](https://www.gate.io/docs/developers/apiv4/en/#funding-rate-history)

## Parameters:

| Parameter | Type     | Required | Description |
|:----------|:---------|:---------|:------------|
| contract  | String   | true     |             |
| limit     | Int64    | false    |             |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Gateio

result = Gateio.Futures.funding_rate(; 
    settle = Gateio.Futures.FundingRate.usdt,
    contract = "BTC_USDT",
)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "t":"2024-04-16T08:00:00",
    "r":0.0001
  },
  ...
]
```
"""
function funding_rate(client::GateioClient, settle::Settle, query::FundingRateQuery)
    return APIsRequest{Vector{FundingRateData}}("GET", "api/v4/futures/$settle/funding_rate", query)(client)
end

function funding_rate(client::GateioClient = Gateio.Futures.public_client; settle::Settle, kw...)
    return funding_rate(client, settle, FundingRateQuery(; kw...))
end

end
