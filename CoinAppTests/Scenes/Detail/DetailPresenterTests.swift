import XCTest
@testable import CoinApp

private final class DetailCoordinatorSpy: DetailCoordinating { }

private final class DetailDisplaySpy: DetailDisplaying {
    private(set) var configureDetailViewCallsCount = 0
    private(set) var configureDetailViewReceivedInvocations: [DetailDTO] = []
    
    func configureDetailView(_ detailDTO: DetailDTO) {
        configureDetailViewCallsCount += 1
        configureDetailViewReceivedInvocations.append(detailDTO)
    }
}

final class DetailPresenterTests: XCTestCase {
    func testConfigureDetail_ShouldCallConfigureDetailViewOnDisplay() {
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
        
        sut.configureDetail(exchangeFake)
        
        XCTAssertEqual(doubles.displaySpy.configureDetailViewCallsCount, 1)
        XCTAssertEqual(doubles.displaySpy.configureDetailViewReceivedInvocations.first?.exchangeId, "any-exchange-id")
        XCTAssertEqual(doubles.displaySpy.configureDetailViewReceivedInvocations.first?.rank, "Rank: 1")
        XCTAssertEqual(doubles.displaySpy.configureDetailViewReceivedInvocations.first?.name, "any-name")
        XCTAssertEqual(doubles.displaySpy.configureDetailViewReceivedInvocations.first?.website, "Website: any-website")
        XCTAssertEqual(doubles.displaySpy.configureDetailViewReceivedInvocations.first?.volume1hrsUsd, "Volume 1 Hour USD: $2.00")
        XCTAssertEqual(doubles.displaySpy.configureDetailViewReceivedInvocations.first?.volume1dayUsd, "Volume 1 Day USD: $3.00")
        XCTAssertEqual(doubles.displaySpy.configureDetailViewReceivedInvocations.first?.volume1mthUsd, "Volume 1 Month USD: $4.00")
    }
}

private extension DetailPresenterTests {
    typealias Doubles = (
        coordinatorSpy: DetailCoordinatorSpy,
        displaySpy: DetailDisplaySpy
    )
    
    func makeSUT() -> (DetailPresenter, Doubles) {
        let coordinatorSpy = DetailCoordinatorSpy()
        let displaySpy = DetailDisplaySpy()
        
        let sut = DetailPresenter(coordinator: coordinatorSpy)
        sut.viewController = displaySpy
        
        let doubles = (coordinatorSpy, displaySpy)
        
        return (sut, doubles)
    }
}
