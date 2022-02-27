import os

/**
 Dependency container.
 */
public final class DependencyContainer: CustomDebugStringConvertible
{
    // MARK: - Private

    // Private storage for dependencies.
    private var dependencies = [String: AnyObject]()

    // Shared container instance
    private static let shared = DependencyContainer()

    // Logger instance.
    private static let log = Logger(subsystem: "dev.jano", category: "injection")

    // Key to register a type with.
    private static func keyForType<T>(_ type: T.Type) -> String {
        let typeDescription = String(describing: T.self)
        /*
         This relies on the following for Optional detection:
         https://developer.apple.com/documentation/swift/expressiblebynilliteral
         > Only the Optional type conforms to ExpressibleByNilLiteral. ExpressibleByNilLiteral
         conformance for types that use nil for other purposes is discouraged.
         */
        if type is ExpressibleByNilLiteral.Type,
            typeDescription.hasPrefix("Optional<"),
            typeDescription.hasSuffix(">")
        {
            // remove the wrapping "Optional<>" so key is just the type,
            // same as if we had registered a non optional type
            return String(typeDescription.dropFirst("Optional<".count).dropLast())
        } else {
            return typeDescription
        }
    }

    // MARK: - Querying state

    /**
     Returns true if the given type is registered.
     - Parameter dependency: dependency whose registration is being queried.
     - Returns: true if the dependency is registered.
     */
    public static func isRegistered<T>(_ dependency: T.Type) -> Bool {
        let key = keyForType(T.self)
        return shared.dependencies[key] != nil
    }

    // MARK: - Registering types

    /**
     Register a factory that returns a new instance per request.

     Use it to create an intance per request or to create an instance that uses additional
     dependencies.
     - Parameter factory: An object that creates a new instance of type `T`.
    */
    public static func register<T>(factory: Factory<T>) {
        let key = keyForType(factory.typeCreated.self)
        shared.dependencies[key] = factory as AnyObject
    }

    /**
     Register an instance.

     If the instance is a reference type it will be treated as a singleton.
     */
    public static func register<T>(_ dependency: T) {
        let key = keyForType(T.self)
        shared.dependencies[key] = dependency as AnyObject
        log.trace("Registered \(key): \(String(describing: dependency))")
    }

    /// Unregisters all dependencies
    public static func unregisterAll() {
        shared.dependencies = [String: AnyObject]()
    }

    // MARK: - Resolving a type

    /**
     Resolves a dependency previously registered.

     If the dependency is non optional and the type wasn’t previously registered,
     it crashes with preconditionFailure.

     - Returns: resolved instance.
     */
    public static func resolve<T>() -> T {
        let key = keyForType(T.self)
        if let factory = shared.dependencies[key] as? Factory<T> {
            return factory.create(DependencyContainer.shared)
        }
        guard let dependency = shared.dependencies[key] as? T else {
            preconditionFailure("No dependency found for key \(key).")
        }
        return dependency
    }
    
    // MARK: - Debugging

    /// Returns a description of the instances registered.
    public static var debugDescription: String {
        DependencyContainer.shared.debugDescription
    }

    /// A textual description of the instances registered, suitable for debugging.
    public var debugDescription: String {
        """
        Container registered \(dependencies.count) dependencies:
        \t\(dependencies.keys.sorted().joined(separator: "\n\t"))
        """
    }
}

private protocol OptionalProtocol {
    func wrappedType() -> Any.Type
}

extension Optional: OptionalProtocol {
    func wrappedType() -> Any.Type {
        return Wrapped.self
    }
}
