import Injection
import XCTest

final class FactoryTests: XCTestCase
{
    // The struct created by a factory is the same struct registered.
    func testFactory() {
        let factory = Factory { container in HomeCoordinator() }
        XCTAssertEqual(String(describing: factory.typeCreated.self), String(describing: HomeCoordinator.self))
    }
}

// MARK: - Test objects

private protocol HomeCoordinating {
    func start() -> String
}

private struct HomeCoordinator: HomeCoordinating {
    func start() -> String { "real" }
}
