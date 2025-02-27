import Foundation

protocol EndpointConfigurable {
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var params: [String: String] { get }
}
