import Foundation

/// A protocol to treat objects as functions that accept inputs and produce outputs.
public protocol Interactable {
    associatedtype Output
    associatedtype Input
    var output: ((Output) -> Void)? { get set }
    func input(_ input: Input)
}
