import UIKit

enum DetailFactory {
    static func make(exchange: Exchange) -> UIViewController {
        let coordinator = DetailCoordinator()
        let presenter = DetailPresenter(coordinator: coordinator)
        let interactor = DetailInteractor(exchange: exchange, presenter: presenter)
        let viewController = DetailViewController(interactor: interactor)
        
        presenter.viewController = viewController
        coordinator.viewController = viewController
        
        return viewController
    }
}
