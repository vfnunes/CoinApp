import XCTest
@testable import CoinApp

private final class HomeCoordinatorSpy: HomeCoordinating {
    private(set) var showExchangeDetailCallsCount = 0
    private(set) var showExchangeDetaildReceivedInvocations: [Exchange] = []
    
    func showExchangeDetail(from exchange: Exchange) {
        showExchangeDetailCallsCount += 1
        showExchangeDetaildReceivedInvocations.append(exchange)
    }
}

private final class HomeDisplaySpy: HomeDisplaying {
    private(set) var startLoadingCallsCount = 0
    
    func startLoading() {
        startLoadingCallsCount += 1
    }
    
    private(set) var stopLoadingCallsCount = 0
    
    func stopLoading() {
        stopLoadingCallsCount += 1
    }
    
    private(set) var showErrorCallsCount = 0
    private(set) var showErrorReceivedInvocations: [String] = []
    
    func showError(_ message: String) {
        showErrorCallsCount += 1
        showErrorReceivedInvocations.append(message)
    }
    
    private(set) var configureViewModelsCallsCount = 0
    private(set) var configureViewModelsReceivedInvocations: [[ExchangeViewModel]] = []
    
    func configureViewModels(_ viewModels: [ExchangeViewModel]) {
        configureViewModelsCallsCount += 1
        configureViewModelsReceivedInvocations.append(viewModels)
    }
}

final class HomePresenterTests: XCTestCase {
    func testStartLoading_ShouldCallStartLoadingOnDisplay() {
        let (sut, doubles) = makeSUT()
        
        sut.startLoading()
        
        XCTAssertEqual(doubles.displaySpy.startLoadingCallsCount, 1)
    }
    
    func testStopLoading_ShouldCallStopLoadingOnDisplay() {
        let (sut, doubles) = makeSUT()
        
        sut.stopLoading()
        
        XCTAssertEqual(doubles.displaySpy.stopLoadingCallsCount, 1)
    }
    
    func testShowAllExchanges_ShouldCallConfigureViewModelsOnDisplay() {
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
        
        sut.showAllExchanges([exchangeFake])
        
        XCTAssertEqual(doubles.displaySpy.configureViewModelsCallsCount, 1)
        XCTAssertEqual(doubles.displaySpy.configureViewModelsReceivedInvocations.first?.first?.exchangeId, "any-exchange-id")
        XCTAssertEqual(doubles.displaySpy.configureViewModelsReceivedInvocations.first?.first?.name, "any-name")
        XCTAssertEqual(doubles.displaySpy.configureViewModelsReceivedInvocations.first?.first?.volume1DayUsd, "$3.00")
    }
    
    func testShowExchangeDetail_ShouldCallShowExchangeDetailOnCoordinator() {
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
        
        XCTAssertEqual(doubles.coordinatorSpy.showExchangeDetailCallsCount, 1)
        XCTAssertEqual(doubles.coordinatorSpy.showExchangeDetaildReceivedInvocations.first?.exchangeId, "any-exchange-id")
        XCTAssertEqual(doubles.coordinatorSpy.showExchangeDetaildReceivedInvocations.first?.rank, 1)
        XCTAssertEqual(doubles.coordinatorSpy.showExchangeDetaildReceivedInvocations.first?.name, "any-name")
        XCTAssertEqual(doubles.coordinatorSpy.showExchangeDetaildReceivedInvocations.first?.website, "any-website")
        XCTAssertEqual(doubles.coordinatorSpy.showExchangeDetaildReceivedInvocations.first?.volume1hrsUsd, 2.0)
        XCTAssertEqual(doubles.coordinatorSpy.showExchangeDetaildReceivedInvocations.first?.volume1dayUsd, 3.0)
        XCTAssertEqual(doubles.coordinatorSpy.showExchangeDetaildReceivedInvocations.first?.volume1mthUsd, 4.0)
    }
    
    func testShowError_ShouldCallShowErrorOnDisplay() {
        let (sut, doubles) = makeSUT()
        
        sut.showError()
        
        XCTAssertEqual(doubles.displaySpy.showErrorCallsCount, 1)
        XCTAssertEqual(doubles.displaySpy.showErrorReceivedInvocations.first, "Ops! Desculpe ocorreu um erro no carregamento das informações")
    }
}

private extension HomePresenterTests {
    typealias Doubles = (
        coordinatorSpy: HomeCoordinatorSpy,
        displaySpy: HomeDisplaySpy
    )
    
    func makeSUT() -> (HomePresenter, Doubles) {
        let coordinatorSpy = HomeCoordinatorSpy()
        let displaySpy = HomeDisplaySpy()
        
        let sut = HomePresenter(coordinator: coordinatorSpy)
        sut.viewController = displaySpy
        
        let doubles = (coordinatorSpy, displaySpy)
        
        return (sut, doubles)
    }
}
