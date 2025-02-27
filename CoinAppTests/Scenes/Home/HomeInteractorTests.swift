import XCTest
@testable import CoinApp

private final class HomePresenterSpy: HomePresenting {
    private(set) var startLoadingCallsCount = 0
    
    func startLoading() {
        startLoadingCallsCount += 1
    }
    
    private(set) var stopLoadingCallsCount = 0
    
    func stopLoading() {
        stopLoadingCallsCount += 1
    }
    
    private(set) var showAllExchangesCallsCount = 0
    private(set) var showAllExchangesReceivedInvocations: [[Exchange]] = []
    
    func showAllExchanges(_ exchanges: [Exchange]) {
        showAllExchangesCallsCount += 1
        showAllExchangesReceivedInvocations.append(exchanges)
    }
    
    private(set) var showExchangeDetailCallsCount = 0
    private(set) var showExchangeDetailReceivedInvocations: [Exchange] = []
    
    func showExchangeDetail(from exchange: Exchange) {
        showExchangeDetailCallsCount += 1
        showExchangeDetailReceivedInvocations.append(exchange)
    }
    
    private(set) var showErrorCallsCount = 0
    
    func showError() {
        showErrorCallsCount += 1
    }
}

private final class HomeServiceMock: HomeServicing {
    private(set) var getAllExchangeCallsCount = 0
    var getAllExchangeReturnValue: Result<[Exchange], Error> = .failure(Api.ApiError.decodeFail)
    
    func getAllExchange(completion: @escaping (Result<[Exchange], Error>) -> Void) {
        getAllExchangeCallsCount += 1
        completion(getAllExchangeReturnValue)
    }
}

final class HomeInteractorTests: XCTestCase {
    func testLoadData_WhenServiceReturnFailure_ShouldCallShowErrorInPresenter() {
        let (sut, doubles) = makeSUT()
        let errorFake = NSError(domain: "com.coinapp", code: -1)
        doubles.serviceMock.getAllExchangeReturnValue = .failure(errorFake)
        
        sut.loadData()
        
        XCTAssertEqual(doubles.presenterSpy.startLoadingCallsCount, 1)
        XCTAssertEqual(doubles.serviceMock.getAllExchangeCallsCount, 1)
        XCTAssertEqual(doubles.presenterSpy.stopLoadingCallsCount, 1)
        XCTAssertEqual(doubles.presenterSpy.showErrorCallsCount, 1)
    }
    
    func testLoadData_WhenServiceReturnSuccess_ShouldCallShowAllExchangesInPresenter() {
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
        doubles.serviceMock.getAllExchangeReturnValue = .success([exchangeFake])
        
        sut.loadData()
        
        XCTAssertEqual(doubles.presenterSpy.startLoadingCallsCount, 1)
        XCTAssertEqual(doubles.serviceMock.getAllExchangeCallsCount, 1)
        XCTAssertEqual(doubles.presenterSpy.stopLoadingCallsCount, 1)
        XCTAssertEqual(doubles.presenterSpy.showAllExchangesCallsCount, 1)
        XCTAssertEqual(doubles.presenterSpy.showAllExchangesReceivedInvocations.first?.first?.exchangeId, "any-exchange-id")
        XCTAssertEqual(doubles.presenterSpy.showAllExchangesReceivedInvocations.first?.first?.rank, 1)
        XCTAssertEqual(doubles.presenterSpy.showAllExchangesReceivedInvocations.first?.first?.name, "any-name")
        XCTAssertEqual(doubles.presenterSpy.showAllExchangesReceivedInvocations.first?.first?.website, "any-website")
        XCTAssertEqual(doubles.presenterSpy.showAllExchangesReceivedInvocations.first?.first?.volume1hrsUsd, 2.0)
        XCTAssertEqual(doubles.presenterSpy.showAllExchangesReceivedInvocations.first?.first?.volume1dayUsd, 3.0)
        XCTAssertEqual(doubles.presenterSpy.showAllExchangesReceivedInvocations.first?.first?.volume1mthUsd, 4.0)
    }
    
    func testShowExchangeDetail_ShouldCallShowExchangeDetailInPresenter() {
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
        
        XCTAssertEqual(doubles.presenterSpy.showExchangeDetailCallsCount, 1)
        XCTAssertEqual(doubles.presenterSpy.showExchangeDetailReceivedInvocations.first?.exchangeId, "any-exchange-id")
        XCTAssertEqual(doubles.presenterSpy.showExchangeDetailReceivedInvocations.first?.rank, 1)
        XCTAssertEqual(doubles.presenterSpy.showExchangeDetailReceivedInvocations.first?.name, "any-name")
        XCTAssertEqual(doubles.presenterSpy.showExchangeDetailReceivedInvocations.first?.website, "any-website")
        XCTAssertEqual(doubles.presenterSpy.showExchangeDetailReceivedInvocations.first?.volume1hrsUsd, 2.0)
        XCTAssertEqual(doubles.presenterSpy.showExchangeDetailReceivedInvocations.first?.volume1dayUsd, 3.0)
        XCTAssertEqual(doubles.presenterSpy.showExchangeDetailReceivedInvocations.first?.volume1mthUsd, 4.0)
    }
}

private extension HomeInteractorTests {
    typealias Doubles = (
        presenterSpy: HomePresenterSpy,
        serviceMock: HomeServiceMock
    )
    
    func makeSUT() -> (HomeInteractor, Doubles) {
        let presenterSpy = HomePresenterSpy()
        let serviceMock = HomeServiceMock()
        
        let sut = HomeInteractor(presenter: presenterSpy, service: serviceMock)
        let doubles = (presenterSpy, serviceMock)
        
        return (sut, doubles)
    }
}
