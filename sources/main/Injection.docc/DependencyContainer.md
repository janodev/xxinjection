# ``Injection/DependencyContainer``
 @Metadata {
     @DocumentationExtension(mergeBehavior: append)
 }

## Usage

### Resolution

Use an annotation to inject that dependency automatically.
```swift
class Controller: UIViewController {
    @Dependency log: Logger
}
```

Resolve to an optional type to avoid a crash resolving a dependency not previously registered.
```swift
// doesn’t crash if not previously registered
let potato: Potato? = DependencyContainer.resolve()
```

Use a factory to create a new instance during a resolution.
```swift
let factory = Factory { container in APIClient() }
DependencyContainer.register(factory: factory)
```

### Registration

Register a dependency.
```swift
// register a type
DependencyContainer.register(Potato())

// resolve
let potato: Potato = DependencyContainer.resolve()
```

Reference types behave as singletons. You can mutate the instance in the dependency container.
```swift
// registers a reference type
class APIClient { /*...*/ }
DependencyContainer.register(APIClient())

// mutates the singleton kept in the dependency container
let apiClient: APIClient = DependencyContainer.resolve()
apiClient.delegate = HeaderDependencyDelegate(bearer: "deadbeef")
```

Registering a type overwrites any previous registration of the same type.
```swift
DependencyContainer.register(HomeCoordinator() as HomeCoordinating)
let coordinator: HomeCoordinating = DependencyContainer.resolve()

// will resolve as a mock
DependencyContainer.register(MockHomeCoordinator() as HomeCoordinating)
let coordinator: HomeCoordinating = DependencyContainer.resolve()
```

See pros and cons of annotation injection in <doc:Injection>.

## Topics 

### Querying state

- ``Injection/DependencyContainer/isRegistered(_:)``

### Registering types

- ``Injection/DependencyContainer/register(_:)``
- ``Injection/DependencyContainer/register(factory:)``
- ``Injection/DependencyContainer/unregisterAll()``

### Resolving a type

- ``Injection/DependencyContainer/resolve()``

### Debugging

- ``Injection/DependencyContainer/debugDescription-swift.property``
- ``Injection/DependencyContainer/debugDescription-swift.type.property``
