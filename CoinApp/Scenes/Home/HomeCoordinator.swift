import UIKit

protocol HomeCoordinating {
    func showExchangeDetail(from exchange: Exchange)
}

final class HomeCoordinator {
    weak var viewController: UIViewController?
}

extension HomeCoordinator: HomeCoordinating {
    func showExchangeDetail(from exchange: Exchange) {
        let detailViewController = DetailFactory.make(exchange: exchange)
        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
