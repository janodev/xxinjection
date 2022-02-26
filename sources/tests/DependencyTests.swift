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

final class DependencyTests: XCTestCase
{
    override func setUp() {
        super.setUp()
        DependencyContainer.unregisterAll()
    }

    // A struct registered with a factory is resolved.
    func testInjectedFactory()
    {
        // GIVEN registered dependency X
        let factory = Factory { container in HomeCoordinator() }
        DependencyContainer.register(factory: factory)
        let object = ObjectWithSpecificDependency()

        // THEN the object is set with the injected dependency
        XCTAssertEqual(object.check(), "real")
    }

    // Asking for a non existent dependency doesn’t crash if the object is optional.
    func testOptionalDependency() {
        // GIVEN an empty container
        // WHEN a request an optional dependency
        let object = ObjectWithOptional()
        // THEN a nil result is returned
        XCTAssertNil(object.coordinator)
    }

    /// A registered protocol is resolved.
    func testInjectedProtocol()
    {
        // GIVEN registered dependency X
        DependencyContainer.register(MockHomeCoordinator() as HomeCoordinating)
        let object = ObjectWithProtocolDependency()

        // THEN the object is set with the injected dependency
        XCTAssertEqual(object.check(), "mock")
    }

    /// A registered struct is resolved.
    func testInjectedStruct()
    {
        // GIVEN registered dependency X and no default value
        DependencyContainer.register(HomeCoordinator() as HomeCoordinator)
        let object = ObjectWithSpecificDependency()

        // THEN the object is set with the injected dependency
        XCTAssertEqual(object.check(), "real")
    }

    /// Once injected, dependencies don’t change if we set a different dependency in the container.
    func testValuesSetDontChange()
    {
        // GIVEN a registered dependency
        DependencyContainer.register(HomeCoordinator() as HomeCoordinating)
        let object = ObjectWithProtocolDependency()

        // WHEN I change the dependency in the container
        DependencyContainer.register(MockHomeCoordinator() as HomeCoordinating)

        // THEN the object continues to have its previous dependency
        XCTAssertEqual(object.check(), "real")

        // THEN future instantiated objects will have the new dependency
        let anotherScreen = ObjectWithProtocolDependency()
        XCTAssertEqual(anotherScreen.check(), "mock")
    }
}

// MARK: - Test objects

// MARK: Mocking a protocol

private protocol HomeCoordinating {
    func start() -> String
}

private struct HomeCoordinator: HomeCoordinating {
    func start() -> String { "real" }
}

private struct MockHomeCoordinator: HomeCoordinating {
    func start() -> String { "mock" }
}

// MARK: Returning different kinds of protocols

/// Object with a dependency on a specific type.
private final class ObjectWithSpecificDependency {
    @Dependency var coordinator: HomeCoordinator
    func check() -> String {
        coordinator.start()
    }
}

/// Object with a dependency on a protocol.
private final class ObjectWithProtocolDependency {
    @Dependency var coordinator: HomeCoordinating
    func check() -> String {
        coordinator.start()
    }
}

private final class ObjectWithOptional {
    @Dependency var coordinator: HomeCoordinating?
    func check() -> String? {
        coordinator?.start()
    }
}
