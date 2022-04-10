/// A type-erased `Identifiable` value.
public struct AnyIdentifiable: Identifiable {
    public let id: AnyHashable
    /// The value conforming to the `Identifiable` protocol.
    public let value: Any

    /// Initializes the type-erased `Identifiable` value.
    ///
    /// - Parameter identifiable: A value conforming to the `Identifiable` protocol.
    public init<T: Identifiable>(_ identifiable: T) {
        id = AnyHashable(identifiable.id)
        value = identifiable
    }
}
