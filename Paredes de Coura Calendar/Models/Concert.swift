import Foundation

struct Concert: Identifiable, Decodable {
    let id: String
    let artist: Artist
    let date: Date
    let stage: Stage
}

#if targetEnvironment(simulator)
extension Concert {
    static func stub(
        id: String = "1",
        artist: Artist = .stub(),
        date: Date = Date(),
        stage: Stage = .stub()
    ) -> Concert {
        Concert(
            id: id,
            artist: artist,
            date: Date(),
            stage: stage
        )
    }
}
#endif
