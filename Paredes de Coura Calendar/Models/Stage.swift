struct Stage: Decodable, Identifiable {
    let id: String
    let name: String
}

#if targetEnvironment(simulator)
extension Stage {
    static func stub(id:String = "1", name: String = "Vodafone") -> Stage {
        .init(id:id, name: name)
    }
}
#endif
