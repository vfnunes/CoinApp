import XCTest
@testable import CoinApp

private final class DetailPresenterSpy: DetailPresenting {
    private(set) var configureDetailCallsCount = 0
    private(set) var configureDetailReceivedInvocations: [Exchange] = []
    
    func configureDetail(_ exchange: Exchange) {
        configureDetailCallsCount += 1
        configureDetailReceivedInvocations.append(exchange)
    }
}

final class DetailInteractorTests: XCTestCase {
    func testLoadData_ShouldCallConfigureDetailOnPresenter() {
        let exchangeFake = Exchange(
            exchangeId: "any-exchange-id",
            rank: 1,
            name: "any-name",
            website: "any-website",
            volume1hrsUsd: 2.0,
            volume1dayUsd: 3.0,
            volume1mthUsd: 4.0
        )
        let (sut, presenterSpy) = makeSUT(exchange: exchangeFake)
        
        sut.loadData()
        
        XCTAssertEqual(presenterSpy.configureDetailCallsCount, 1)
        XCTAssertEqual(presenterSpy.configureDetailReceivedInvocations.first?.exchangeId, "any-exchange-id")
        XCTAssertEqual(presenterSpy.configureDetailReceivedInvocations.first?.rank, 1)
        XCTAssertEqual(presenterSpy.configureDetailReceivedInvocations.first?.name, "any-name")
        XCTAssertEqual(presenterSpy.configureDetailReceivedInvocations.first?.website, "any-website")
        XCTAssertEqual(presenterSpy.configureDetailReceivedInvocations.first?.volume1hrsUsd, 2.0)
        XCTAssertEqual(presenterSpy.configureDetailReceivedInvocations.first?.volume1dayUsd, 3.0)
        XCTAssertEqual(presenterSpy.configureDetailReceivedInvocations.first?.volume1mthUsd, 4.0)
    }
}

private extension DetailInteractorTests {
    func makeSUT(exchange: Exchange) -> (DetailInteractor, DetailPresenterSpy) {
        let presenterSpy = DetailPresenterSpy()
        let sut = DetailInteractor(exchange: exchange, presenter: presenterSpy)
        
        return (sut, presenterSpy)
    }
}
