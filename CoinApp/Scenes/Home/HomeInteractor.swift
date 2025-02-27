import Foundation

protocol HomeInteractoring {
    func loadData()
    func showExchangeDetail(from exchange: Exchange)
}

final class HomeInteractor {
    private let presenter: HomePresenting
    private let service: HomeServicing
    
    init(presenter: HomePresenting, service: HomeServicing) {
        self.presenter = presenter
        self.service = service
    }
}

extension HomeInteractor: HomeInteractoring {
    func loadData() {
        presenter.startLoading()
        service.getAllExchange { [weak self] result in
            self?.presenter.stopLoading()
            switch result {
            case .success(let value):
                self?.presenter.showAllExchanges(value)
            case .failure:
                self?.presenter.showError()
            }
        }
    }
    
    func showExchangeDetail(from exchange: Exchange) {
        presenter.showExchangeDetail(from: exchange)
    }
}
