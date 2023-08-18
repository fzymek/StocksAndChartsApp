import XCTest
@testable import StocksAndChartsKit

final class ModelTests: XCTestCase {

    func test_init() {
        let model = Model(a: "Hello")
        XCTAssertEqual(model.a, "Hello")
    }

}
