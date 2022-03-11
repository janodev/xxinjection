import os

/**
 A property wrapper that injects the given type.

 Usage:
 ```
 @Dependency var log: Logger
 @Dependency var coredataStack: CoreDataStack?
 ```

 If the type wasn’t registered previously:

 - If it is optional it returns nil.
 - If it is non optional it crashes with `preconditionFailure`.
 */
@propertyWrapper
public struct Dependency<T>
{
    /// Type to inject by this annotation.
    public var wrappedValue: T

    /// Creates a value instance and resolves the type.
    public init() {
        self.wrappedValue = DependencyContainer.resolve()
    }
}
