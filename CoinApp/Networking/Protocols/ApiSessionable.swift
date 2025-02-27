import Foundation

protocol ApiSessionable {
    @discardableResult
    func execute<Success: Decodable>(_ endpoint: EndpointConfigurable, completion: @escaping (Result<Success, Error>) -> Void) -> URLSessionTask?
}
