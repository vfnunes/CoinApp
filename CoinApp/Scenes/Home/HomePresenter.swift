import Foundation

protocol HomePresenting {
    func startLoading()
    func stopLoading()
    func showAllExchanges(_ exchanges: [Exchange])
    func showExchangeDetail(from exchange: Exchange)
    func showError()
}

final class HomePresenter {
    private let coordinator: HomeCoordinating
    weak var viewController: HomeDisplaying?
    
    init(coordinator: HomeCoordinating) {
        self.coordinator = coordinator
    }
}

extension HomePresenter: HomePresenting {
    func startLoading() {
        viewController?.startLoading()
    }
    
    func stopLoading() {
        viewController?.stopLoading()
    }
    
    func showAllExchanges(_ exchanges: [Exchange]) {
        let viewModels = exchanges.map {
            ExchangeViewModel(
                exchangeId: $0.exchangeId,
                name: $0.name ?? "EMPTY",
                volume1DayUsd: $0.volume1dayUsd.formatterToDollar(),
                data: $0
            )
        }
        viewController?.configureViewModels(viewModels)
    }
    
    func showExchangeDetail(from exchange: Exchange) {
        coordinator.showExchangeDetail(from: exchange)
    }
    
    func showError() {
        viewController?.showError("Ops! Desculpe ocorreu um erro no carregamento das informações")
    }
}
