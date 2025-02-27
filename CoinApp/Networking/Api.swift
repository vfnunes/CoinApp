import Foundation

final class Api: ApiSessionable {
    private let sessionConfiguration: URLSessionConfiguration
    
    init(sessionConfiguration: URLSessionConfiguration = .default) {
        self.sessionConfiguration = sessionConfiguration
    }
    
    @discardableResult
    func execute<Success>(
        _ endpoint: any EndpointConfigurable,
        completion: @escaping (Result<Success, Error>) -> Void
    ) -> URLSessionTask? where Success: Decodable {
        let urlSession = makeUrlSession()
        var urlSessionTask: URLSessionTask?
        
        do {
            let urlRequest = try makeUrlRequest(endpoint)
            
            urlSessionTask = urlSession.dataTask(with: urlRequest) { data, _, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(ApiError.emptyResponseData))
                    return
                }
                
                if let valueDecoded = try? JSONDecoder().decode(Success.self, from: data) {
                    completion(.success(valueDecoded))
                } else {
                    completion(.failure(ApiError.decodeFail))
                }
            }
            urlSessionTask?.resume()
            
        } catch {
            completion(.failure(error))
        }
        
        return urlSessionTask
    }
    
    // MARK: - Private Methods
    private func makeUrlSession() -> URLSession {
        URLSession(configuration: sessionConfiguration)
    }
    
    private func makeUrlRequest(_ endpoint: EndpointConfigurable) throws -> URLRequest {
        guard var urlComponents = URLComponents(string: "\(endpoint.host)\(endpoint.path)") else {
            throw ApiError.invalidHost
        }
        
        urlComponents.queryItems = endpoint.params.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = urlComponents.url else {
            throw ApiError.invalidQueryParams
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        
        endpoint.headers.forEach {
            urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
        }
    
        return urlRequest
    }
}

extension Api {
    enum ApiError: Error {
        case invalidHost
        case invalidQueryParams
        case emptyResponseData
        case decodeFail
    }
}
