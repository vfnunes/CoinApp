import XCTest
@testable import CoinApp

private final class NavigationControllerSpy: UINavigationController {
    
    private(set) var pushViewControllerCallsCount = 0
    private(set) var pushViewControllerReceivedInvocations: [(viewController: UIViewController, animated: Bool)] = []
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushViewControllerCallsCount += 1
        pushViewControllerReceivedInvocations.append((viewController: viewController, animated: animated))
    }
}

private final class ViewControllerSpy: UIViewController {
    private let navigationControllerSpy: NavigationControllerSpy
    
    override var navigationController: UINavigationController? {
        navigationControllerSpy
    }
    
    init(navigationControllerSpy: NavigationControllerSpy) {
        self.navigationControllerSpy = navigationControllerSpy
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class HomeCoordinatorTests: XCTestCase {
    func testShowExchangeDetail_ShouldPushDetailViewController() {
        let (sut, doubles) = makeSUT()
        let exchangeFake = Exchange(
            exchangeId: "any-exchange-id",
            rank: 1,
            name: "any-name",
            website: "any-website",
            volume1hrsUsd: 2.0,
            volume1dayUsd: 3.0,
            volume1mthUsd: 4.0
        )
        
        sut.showExchangeDetail(from: exchangeFake)
        
        XCTAssertEqual(doubles.navigationControllerSpy.pushViewControllerCallsCount, 1)
        XCTAssertTrue(doubles.navigationControllerSpy.pushViewControllerReceivedInvocations.first?.viewController is DetailViewController)
        XCTAssertEqual(doubles.navigationControllerSpy.pushViewControllerReceivedInvocations.first?.animated, true)
    }
}

private extension HomeCoordinatorTests {
    typealias Doubles = (
        viewControllerSpy: ViewControllerSpy,
        navigationControllerSpy: NavigationControllerSpy
    )
    
    func makeSUT() -> (HomeCoordinator, Doubles) {
        let navigationControllerSpy = NavigationControllerSpy()
        let viewControllerSpy = ViewControllerSpy(navigationControllerSpy: navigationControllerSpy)
        let sut = HomeCoordinator()
        sut.viewController = viewControllerSpy
        
        let doubles = (viewControllerSpy, navigationControllerSpy)
        
        return (sut, doubles)
    }
}
