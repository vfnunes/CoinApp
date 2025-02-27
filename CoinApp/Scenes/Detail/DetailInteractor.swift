import Foundation

protocol DetailInteractoring {
    func loadData()
}

final class DetailInteractor {
    private let exchange: Exchange
    private let presenter: DetailPresenting
    
    init(exchange: Exchange, presenter: DetailPresenting) {
        self.exchange = exchange
        self.presenter = presenter
    }
}

extension DetailInteractor: DetailInteractoring {
    func loadData() {
        presenter.configureDetail(exchange)
    }
}
