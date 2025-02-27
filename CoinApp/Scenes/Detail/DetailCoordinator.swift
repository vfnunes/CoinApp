import UIKit

protocol DetailCoordinating { }

final class DetailCoordinator {
    weak var viewController: UIViewController?
}

extension DetailCoordinator: DetailCoordinating { }
