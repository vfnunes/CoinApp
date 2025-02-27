import Foundation

protocol DetailPresenting {
    func configureDetail(_ exchange: Exchange)
}

final class DetailPresenter {
    private let coordinator: DetailCoordinating
    weak var viewController: DetailDisplaying?
    
    init(coordinator: DetailCoordinating) {
        self.coordinator = coordinator
    }
}

extension DetailPresenter: DetailPresenting {
    func configureDetail(_ exchange: Exchange) {
        let detailDto = DetailDTO(
            exchangeId: exchange.exchangeId,
            rank: "\(exchange.rank)",
            name: exchange.name ?? "EMPTY",
            website: exchange.website ?? "EMPTY",
            volume1hrsUsd: exchange.volume1hrsUsd.formatterToDollar(),
            volume1dayUsd: exchange.volume1dayUsd.formatterToDollar(),
            volume1mthUsd: exchange.volume1mthUsd.formatterToDollar()
        )
        
        viewController?.configureDetailView(detailDto)
    }
}
