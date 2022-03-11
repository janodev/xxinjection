# ``Injection``

A minimal dependency container to inject dependencies via property wrapper.

Annotations are the shortest initializer pattern. Mind the differences:

```swift
// annotations
class Controller: UIViewController {
    @Dependency private log: Logger
}

// initializer
class Controller: UIViewController {
    private log: Logger
    init(log: Logger) {
        self.log = log
    }
}
```

Benefits:

- Less verbose.
- No need to pass parameters along just to create other objects.
- Knowledge of dependency creation is kept in the container.
- Easy to mock by replacing dependencies.

Cons:

- Coupling with the container.
- Dependencies of an object are are not visible during its creation. 

## Usage 

See ``DependencyContainer``.

## Implementation

The implementation is three objects and 150 lines.

- ``Dependency``
- ``DependencyContainer``
- ``Factory``

![Class diagram](class-diagram.png)
