struct Artist: Identifiable, Decodable {
    let id: String
    let name: String
    let imagePath: String
}

#if targetEnvironment(simulator)
extension Artist {
    static func stub(
        id: String = "1",
        name: String = "Fever Ray",
        imagePath: String = "www.imageurl.com"
    ) -> Artist {
        .init(
            id: id,
            name: name,
            imagePath: imagePath
        )
    }
}
#endif
