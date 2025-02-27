import Foundation

enum ExchangeRatesEndpoint: EndpointConfigurable {
    case allExchangeRates
    case singleExchangeRate(exchangeId: String)
    
    var host: String { "https://rest.coinapi.io/" }
    
    var path: String {
        switch self {
        case .allExchangeRates:
            return "v1/exchanges"
        case .singleExchangeRate(let exchangeId):
            return "v1/exchanges/\(exchangeId)"
        }
    }
    
    var method: HTTPMethod { .get }
    
    var headers: [String: String] {
        ["X-CoinAPI-Key": "758e8a93-0b7c-416a-9776-eff844a9b4d3"]
    }
    
    var params: [String: String] {
        switch self {
        case .singleExchangeRate(let exchangeId):
            return ["exchange_id": exchangeId]
        default:
            return [:]
        }
    }
}
