public struct AnyIdentifiable: Identifiable, Hashable {
    public let id: AnyHashable
    public let value: AnyHashable

    public init<T: Identifiable>(_ identifiable: T) where T: Hashable {
        self.id = AnyHashable(identifiable.id)
        self.value = identifiable
    }
}
