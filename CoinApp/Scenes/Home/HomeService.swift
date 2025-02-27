import Foundation

protocol HomeServicing {
    func getAllExchange(completion: @escaping (Result<[Exchange], Error>) -> Void)
}

final class HomeService {
    private let api: ApiSessionable
    
    init(api: ApiSessionable = Api()) {
        self.api = api
    }
}

extension HomeService: HomeServicing {
    func getAllExchange(completion: @escaping (Result<[Exchange], Error>) -> Void) {
        let endpoint = ExchangeRatesEndpoint.allExchangeRates
        api.execute(endpoint) { (result: Result<[Exchange], Error>) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
