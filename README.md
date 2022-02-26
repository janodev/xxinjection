Dependency injection using property wrappers.

### Registering types:
```swift
// injecting a type
DependencyContainer.register(HomeCoordinator())

// injecting a type as a protocol
DependencyContainer.register(MockHomeCoordinator() as HomeCoordinating)

// using a factory
let factory = Factory { container in HomeCoordinator() }
DependencyContainer.register(factory: factory)
```

### Resolving
```swift
// using through a property wrapper
final class ObjectWithProtocolDependency {
    
    @Dependency var coordinator: HomeCoordinating
    
    func check() -> String {
        coordinator.start()
    }
}

// resolving manually
let log = DependencyContainer.resolve() as Logger
```

See the [documentation](https://janodev.github.io/injection/documentation/injection/).
