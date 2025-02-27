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
            rank: "Rank: \(exchange.rank)",
            name: exchange.name ?? "EMPTY",
            website: "Website: \(exchange.website ?? "EMPTY")",
            volume1hrsUsd: "Volume 1 Hour USD: \(exchange.volume1hrsUsd.formatterToDollar())",
            volume1dayUsd: "Volume 1 Day USD: \(exchange.volume1dayUsd.formatterToDollar())",
            volume1mthUsd: "Volume 1 Month USD: \(exchange.volume1mthUsd.formatterToDollar())"
        )
        
        viewController?.configureDetailView(detailDto)
    }
}
